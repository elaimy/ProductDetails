//
//  SwiftUIView.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 18/04/2025.
//

import SwiftUI

struct SwiftUIView: View {
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                // Product Image Carousel
                ProductImageCarousel(
                    currentPage: $viewModel.currentPage,
                    imageURLs: viewModel.imageURLs,
                    startAutoScroll: viewModel.startAutoScrollTimer,
                    stopAutoScroll: viewModel.stopAutoScrollTimer
                )
                .frame(height: 300)
                
                // Product Info Section
                VStack(alignment: .trailing, spacing: 8) {
                    Text(viewModel.selectedProduct?.name ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    HStack {
                        Text(viewModel.selectedProduct?.sku ?? "")
                            .multilineTextAlignment(.trailing)
                        Text(":كود المنتج")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.trailing)
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    HStack {
                        // Reverse order for RTL layout:
                        // Arrival Label on right, In Stock label on left
                        
                        // Arrival Label
                        HStack(spacing: 4) {
                            Text(viewModel.selectedProduct?.shipTo.period ?? "")
                                .font(.caption)
                                .multilineTextAlignment(.trailing)
                            Image(systemName: "shippingbox.fill")
                                .foregroundColor(Color(hex: "665BCB"))
                            Text("يصل في")
                                .font(.caption)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        Spacer()
                        
                        // "In Stock" Label
                        let isInStock = viewModel.selectedProduct?.stockStatus == "IN_STOCK"
                        Text(isInStock ? "متوفر في المخزن" : "غير متوفر")
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(isInStock ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                            .foregroundColor(isInStock ? .green : .red)
                            .cornerRadius(4)
                            .font(.caption)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    // Color Selection
                    HStack(alignment: .center) {
                        // Reverse order for RTL layout:
                        // Color label first (on right), then color selector (on left)
                        
                        // Color label
                        if !viewModel.colorOptions.isEmpty {
                            Text("اللون \(viewModel.colorOptions[viewModel.selectedColorIndex].label)")
                                .font(.headline)
                                .multilineTextAlignment(.trailing)
                                .frame(alignment: .trailing)
                        }
                        
                        Spacer()
                        
                        // Color circles
                        ColorSelector(
                            colorOptions: viewModel.colorOptions,
                            selectedIndex: $viewModel.selectedColorIndex,
                            onColorSelected: { index in
                                viewModel.selectColor(at: index)
                            }
                        )
                        .frame(height: 40)
                    }
                }
                .padding(.horizontal, 16)
                
                // Segmented Control
                CustomSegmentedControl(
                    selectedIndex: $viewModel.selectedSegmentIndex,
                    segments: ["وصف المنتج", "معلومات إضافية", "اراء العملاء"]
                )
                .padding(.top, 8)
                
                // Tab Content
                VStack {
                    switch viewModel.selectedSegmentIndex {
                    case 0:
                        ProductDescriptionContent(items: viewModel.productDescItems)
                    case 1:
                        AdditionalInfoContent(items: viewModel.additionalInfoItems)
                    case 2:
                        CustomerReviewsContent(
                            reviews: viewModel.customerReviewItems,
                            isReviewsVisible: $viewModel.isReviewsVisible
                        )
                    default:
                        EmptyView()
                    }
                }
                .animation(.easeInOut, value: viewModel.selectedSegmentIndex)
                .padding(.bottom, 24)
            }
        }
        .environment(\.layoutDirection, .rightToLeft) // For RTL support
        .environment(\.multilineTextAlignment, .trailing) // Default text alignment for all Text views
        .onAppear {
            viewModel.startAutoScrollTimer()
        }
        .onDisappear {
            viewModel.stopAutoScrollTimer()
        }
    }
}

#Preview {
    SwiftUIView()
}
