import SwiftUI

// Common styling for all tab content
struct ContentContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    .background(Color.white.cornerRadius(16))
            )
            .padding(.horizontal, 16)
    }
}

// Tab 1: Product Description
struct ProductDescriptionContent: View {
    let items: [String]
    
    var body: some View {
        ContentContainer {
            VStack(spacing: 0) {
                ForEach(0..<items.count, id: \.self) { index in
                    Text(items[index])
                        .font(.system(size: 14))
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .background(getBackgroundColor(for: index))
                }
            }
            .cornerRadius(16)
        }
    }
    
    private func getBackgroundColor(for index: Int) -> Color {
        // Mimicking the UIKit pattern for background colors
        switch index {
        case 0:
            return Color(hex: "F1FCFE")
        case 1, 2:
            return Color.white
        case 3, 4, 5, 6, 7:
            return Color(hex: "F1FCFE")
        default:
            return index % 2 == 0 ? Color(hex: "F1FCFE") : Color.white
        }
    }
}

// Tab 2: Additional Information
struct AdditionalInfoContent: View {
    let items: [(title: String, description: String)]
    
    var body: some View {
        ContentContainer {
            VStack(spacing: 0) {
                ForEach(0..<items.count, id: \.self) { index in
                    HStack {
                        Text("\(items[index].title):")
                            .font(.system(size: 14, weight: .bold))
                            .multilineTextAlignment(.trailing)
                            .frame(alignment: .trailing)
                        
                        Spacer()
                        
                        Text("\(items[index].description)")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.trailing)
                            .frame(alignment: .trailing)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    
                    if index < items.count - 1 {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }
                }
            }
            .cornerRadius(16)
        }
    }
}

// Tab 3: Customer Reviews
struct CustomerReviewsContent: View {
    let reviews: [String]
    @Binding var isReviewsVisible: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            ContentContainer {
                VStack(spacing: 0) {
                    ForEach(0..<reviews.count, id: \.self) { index in
                        Text(reviews[index])
                            .font(.system(size: 14))
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .background(index % 2 == 0 ? Color(hex: "F1FCFE") : Color.white)
                        
                        if index < reviews.count - 1 {
                            Divider()
                                .background(Color.gray.opacity(0.3))
                        }
                    }
                }
                .cornerRadius(16)
            }
            
            // Reviews UI
            if isReviewsVisible {
                VStack(spacing: 8) {
                    Text("مراجعات العملاء")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    // Rating UI would go here
                    HStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    // Review form would go here
                    Text("إضافة مراجعة")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "665BCB"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 16)
            }
        }
    }
}

// Tab 4: Product Attributes
struct ProductAttributesContent: View {
    let attributes: [ProductAttribute]
    
    var body: some View {
        ContentContainer {
            VStack(spacing: 0) {
                ForEach(0..<attributes.count, id: \.self) { index in
                    HStack {
                        Text(attributes[index].label)
                            .font(.system(size: 14, weight: .bold))
                            .multilineTextAlignment(.trailing)
                            .frame(alignment: .trailing)
                        
                        Spacer()
                        
                        Text(attributes[index].value)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.trailing)
                            .frame(alignment: .trailing)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background(index % 2 == 0 ? Color(hex: "F1FCFE") : Color.white)
                    
                    if index < attributes.count - 1 {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }
                }
            }
            .cornerRadius(16)
        }
    }
} 