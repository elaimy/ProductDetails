import SwiftUI
import Combine

// ImageCache for caching loaded images
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

// CachedAsyncImage for better performance
struct CachedAsyncImage<Content: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = url.flatMap({ ImageCache.shared.get(forKey: $0.absoluteString) }) {
            content(.success(Image(uiImage: cached)))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase, let url = url {
            Task {
                if let uiImage = image.asUIImage() {
                    ImageCache.shared.set(image: uiImage, forKey: url.absoluteString)
                }
            }
        }
        return content(phase)
    }
}

// Extension to convert SwiftUI Image to UIImage
extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        
        // Set the controller's view size to the image size
        if let view = controller.view {
            let size = view.intrinsicContentSize
            view.bounds = CGRect(origin: .zero, size: size)
            
            // Force the view to update
            view.setNeedsLayout()
            view.layoutIfNeeded()
            
            // Render the view to an image
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { _ in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
        }
        return nil
    }
} 