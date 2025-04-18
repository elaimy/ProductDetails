import SwiftUI
import Combine

struct ProductImageCarousel: View {
    @Binding var currentPage: Int
    let imageURLs: [String]
    var onPageChange: ((Int) -> Void)? = nil
    
    // Timer control
    var startAutoScroll: () -> Void
    var stopAutoScroll: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage.animation()) {
                ForEach(0..<imageURLs.count, id: \.self) { index in
                    CachedAsyncImage(url: URL(string: imageURLs[index])) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .clipped()
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: currentPage) { newValue in
                onPageChange?(newValue)
            }
            
            // Custom Page Control
            HStack(spacing: 8) {
                ForEach(0..<imageURLs.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color(hex: "665BCB") : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 16)
            
            // Navigation buttons
            HStack {
                // Left Button
                Button(action: {
                    stopAutoScroll()
                    currentPage = (currentPage - 1 + imageURLs.count) % imageURLs.count
                    startAutoScroll()
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(hex: "665BCB"))
                        .padding(12)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                
                Spacer()
                
                // Right Button
                Button(action: {
                    stopAutoScroll()
                    currentPage = (currentPage + 1) % imageURLs.count
                    startAutoScroll()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(hex: "665BCB"))
                        .padding(12)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            startAutoScroll()
        }
        .onDisappear {
            stopAutoScroll()
        }
        // Stop the timer during dragging
        .gesture(DragGesture().onChanged { _ in
            stopAutoScroll()
        }.onEnded { _ in
            startAutoScroll()
        })
    }
}

#Preview {
    ProductImageCarousel(
        currentPage: .constant(0), 
        imageURLs: ["https://example.com/image1.jpg", "https://example.com/image2.jpg"],
        startAutoScroll: {},
        stopAutoScroll: {}
    )
    .frame(height: 300)
} 
