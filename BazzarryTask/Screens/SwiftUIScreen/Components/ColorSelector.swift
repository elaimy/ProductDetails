import SwiftUI

struct ColorSelector: View {
    let colorOptions: [OptionValue]
    @Binding var selectedIndex: Int
    var onColorSelected: ((Int) -> Void)
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<colorOptions.count, id: \.self) { index in
                    let colorOption = colorOptions[index]
                    
                    Button(action: {
                        selectedIndex = index
                        onColorSelected(index)
                    }) {
                        ZStack {
                            // Color circle
                            Circle()
                                .fill(Color(hex: colorOption.swatchData.value))
                                .frame(width: 28, height: 28)
                            
                            // Selection indicator
                            if selectedIndex == index {
                                Circle()
                                    .stroke(Color(hex: "665BCB"), lineWidth: 2)
                                    .frame(width: 32, height: 32)
                            }
                        }
                        .frame(width: 32, height: 32)
                    }
                }
            }
            .padding(.horizontal, 10)
            .environment(\.layoutDirection, .rightToLeft) // For RTL support
        }
    }
}

#Preview {
    ColorSelector(
        colorOptions: [
            OptionValue(valueIndex: 1, label: "أسود", swatchData: SwatchData(value: "000000")),
            OptionValue(valueIndex: 2, label: "أحمر", swatchData: SwatchData(value: "FF0000")),
            OptionValue(valueIndex: 3, label: "أزرق", swatchData: SwatchData(value: "0000FF"))
        ],
        selectedIndex: .constant(0),
        onColorSelected: { _ in }
    )
} 