import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedIndex: Int
    let segments: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<segments.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                    }
                }) {
                    Text(segments[index])
                        .font(.system(size: 12, weight: selectedIndex == index ? .semibold : .regular))
                        .foregroundColor(selectedIndex == index ? .black : .gray)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .overlay(
                    Rectangle()
                        .frame(height: selectedIndex == index ? 2 : 1)
                        .foregroundColor(selectedIndex == index ? .black : .gray.opacity(0.3))
                        .offset(y: 12),
                    alignment: .bottom
                )
            }
        }
        .environment(\.layoutDirection, .rightToLeft) // For RTL support
    }
}

#Preview {
    CustomSegmentedControl(
        selectedIndex: .constant(0),
        segments: ["وصف المنتج", "معلومات إضافية", "اراء العملاء"]
    )
} 
