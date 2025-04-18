import Foundation
import Combine
import SwiftUI

class ProductViewModel: ObservableObject {
    // Published properties
    @Published var products: [Product] = []
    @Published var imageURLs: [String] = []
    @Published var colorOptions: [OptionValue] = []
    @Published var selectedColorIndex: Int = 0
    @Published var currentPage: Int = 0
    @Published var selectedSegmentIndex: Int = 0
    @Published var isReviewsVisible: Bool = false
    
    // Tab content data
    @Published var productDescItems: [String] = []
    @Published var additionalInfoItems: [(title: String, description: String)] = []
    @Published var customerReviewItems: [String] = []
    @Published var productAttributes: [ProductAttribute] = []
    
    // Selected product info
    @Published var selectedProduct: Product?
    @Published var selectedVariant: VariantProduct?
    
    // Combine cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // Timer for auto-scrolling
    private var autoScrollTimer: Timer?
    
    init() {
        setupBindings()
        loadProductData()
    }
    
    deinit {
        stopAutoScrollTimer()
    }
    
    private func setupBindings() {
        // Update reviews visibility when segment changes
        $selectedSegmentIndex
            .sink { [weak self] index in
                self?.isReviewsVisible = index == 2
            }
            .store(in: &cancellables)
    }
    
    func loadProductData() {
        guard let jsonData = readLocalJSONFile(forName: "response") else {
            print("Failed to load JSON file")
            return
        }
        
        do {
            let productResponse = try JSONDecoder().decode(ProductResponse.self, from: jsonData)
            
            // Get all product items
            self.products = productResponse.data.products.items
            
            // Extract data from the first product
            if let firstProduct = products.first {
                self.selectedProduct = firstProduct
                
                // Get image URLs from media gallery
                self.imageURLs = firstProduct.mediaGallery.map { $0.url }
                
                // Extract color options
                for option in firstProduct.configurableOptions {
                    if option.attributeCode.lowercased() == "color" {
                        self.colorOptions = option.values
                        break
                    }
                }
                
                // Extract product description
                let htmlDescription = firstProduct.productDescription.html
                
                // Try different approach for cleaning HTML
                let plainDescription = htmlDescription
                    .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    .replacingOccurrences(of: "&nbsp;", with: "§MARKER§") // Replace with a unique marker
                
                // Split the description into paragraphs
                let paragraphs = plainDescription.components(separatedBy: "\n")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                
                // Process paragraphs to handle marker
                self.productDescItems = []
                for paragraph in paragraphs {
                    if paragraph.contains("§MARKER§") {
                        // Add the paragraph with the marker intact (will be processed in view)
                        self.productDescItems.append(paragraph.replacingOccurrences(of: "§MARKER§", with: ""))
                    } else {
                        // Add paragraph as is
                        self.productDescItems.append(paragraph)
                    }
                }
                
                // Simulate additional info items
                self.additionalInfoItems = [
                    ("المقاس", "قياسي"),
                    ("اللون", "أسود، بني"),
                    ("المواد", "جلد طبيعي، ألومنيوم"),
                    ("السعة", "8 بطاقات"),
                    ("الوزن", "50 جرام")
                ]
                
                // Simulate customer reviews
                self.customerReviewItems = [
                    "تصميم رائع وعملي جداً. أستخدمها منذ شهر ولا توجد أي مشاكل.",
                    "المحفظة خفيفة وسهلة الحمل، أعجبني جداً النظام الأوتوماتيكي لإخراج البطاقات.",
                    "جودة عالية مقابل السعر. أنصح بها لكل من يبحث عن محفظة عملية."
                ]
                
                // Extract product attributes
                self.productAttributes = firstProduct.attributes
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func startAutoScrollTimer() {
        stopAutoScrollTimer()
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.imageURLs.isEmpty else { return }
            self.currentPage = (self.currentPage + 1) % self.imageURLs.count
        }
    }
    
    func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    func selectColor(at index: Int) {
        guard index < colorOptions.count else { return }
        
        selectedColorIndex = index
        
        // Find the variant with this color
        if let product = products.first, let variant = findVariantWithColor(
            product: product, 
            colorValueIndex: colorOptions[index].valueIndex
        ) {
            selectedVariant = variant.product
        }
    }
    
    private func findVariantWithColor(product: Product, colorValueIndex: Int) -> Variant? {
        // Find the variant that has the selected color attribute
        for variant in product.variants {
            for attribute in variant.attributes {
                if attribute.code.lowercased() == "color" && attribute.valueIndex == colorValueIndex {
                    return variant
                }
            }
        }
        return nil
    }
    
    private func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("Error reading local JSON file: \(error)")
        }
        
        return nil
    }
}

// MARK: - Helper Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 