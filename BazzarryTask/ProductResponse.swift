//
//  ProductResponse.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 16/04/2025.
//

import Foundation

// MARK: - Root Response
struct ProductResponse: Codable {
    let data: ProductsData
}

struct ProductsData: Codable {
    let products: Products
}

struct Products: Codable {
    let items: [Product]
}

// MARK: - Main Product Structure
struct Product: Codable {
    let salableQty: Int
    let stockStatus: String
    let id: Int
    let name: String
    let sku: String
    let typeId: String
    let approval: Int
    let shipTo: ShipTo
    let labels: [Label]?
    let productDescription: ProductDescription
    let smallImage: ImageResource
    let urlRewrites: [URLRewrite]
    let priceRange: PriceRange
    let categories: [Category]
    let mediaGallery: [ImageResource]
    let ratingSummary: Int
    let reviewCount: Int
    let reviewAvailability: Int
    let reviews: Reviews
    let attributes: [ProductAttribute]
    let vendorInfo: VendorInfo
    let productFeatures: ProductFeatures
    let configurableOptions: [ConfigurableOption]
    let variants: [Variant]

    enum CodingKeys: String, CodingKey {
        case salableQty = "salable_qty"
        case stockStatus = "stock_status"
        case id, name, sku
        case typeId = "type_id"
        case approval
        case shipTo = "ship_to"
        case labels
        case productDescription = "description"
        case smallImage = "small_image"
        case urlRewrites = "url_rewrites"
        case priceRange = "price_range"
        case categories
        case mediaGallery = "media_gallery"
        case ratingSummary = "rating_summary"
        case reviewCount = "review_count"
        case reviewAvailability = "review_availability"
        case reviews, attributes
        case vendorInfo
        case productFeatures = "product_features"
        case configurableOptions = "configurable_options"
        case variants
    }
}

// MARK: - Supporting Models

struct ShipTo: Codable {
    let prefix: String
    let icon: String
    let period: String
}

struct Label: Codable {
    let title: String
    let labelText: String
    let labelImage: String?
    let backgroundImage: String?
    let customStyle: String?

    enum CodingKeys: String, CodingKey {
        case title
        case labelText = "label_text"
        case labelImage = "label_image"
        case backgroundImage = "background_image"
        case customStyle = "custom_style"
    }
}

struct ProductDescription: Codable {
    let html: String
}

struct ImageResource: Codable {
    let url: String
}

struct URLRewrite: Codable {
    let url: String
}

struct PriceRange: Codable {
    let maximumPrice: PriceDetail
    let minimumPrice: PriceDetail

    enum CodingKeys: String, CodingKey {
        case maximumPrice = "maximum_price"
        case minimumPrice = "minimum_price"
    }
}

struct PriceDetail: Codable {
    let regularPrice: Price
    let regularPriceBase: Price
    let finalPrice: Price
    let finalPriceBase: Price
    let discount: Discount
    let discountBase: Discount

    enum CodingKeys: String, CodingKey {
        case regularPrice = "regular_price"
        case regularPriceBase = "regular_price_base"
        case finalPrice = "final_price"
        case finalPriceBase = "final_price_base"
        case discount
        case discountBase = "discount_base"
    }
}

struct Price: Codable {
    let currency: String
    let value: Double
}

struct Discount: Codable {
    let amountOff: Double
    let percentOff: Double

    enum CodingKeys: String, CodingKey {
        case amountOff = "amount_off"
        case percentOff = "percent_off"
    }
}

struct Category: Codable {
    let id: Int
    let name: String
}

struct Reviews: Codable {
    let items: [Review]
}

struct Review: Codable {
    // Define review fields if needed (this sample JSON contains an empty array).
}

struct ProductAttribute: Codable {
    let label: String
    let code: String
    let value: String
}

struct VendorInfo: Codable {
    let vendorId: Int
    let productsCount: String
    let joinedDate: String
    let vendorRegionName: String
    let vendorCountry: String
    let storeName: String?
    let logoUrl: String

    enum CodingKeys: String, CodingKey {
        case vendorId = "vendor_id"
        case productsCount = "products_count"
        case joinedDate = "joined_date"
        case vendorRegionName = "vendor_region_name"
        case vendorCountry = "vendor_country"
        case storeName = "store_name"
        case logoUrl = "logo_url"
    }
}

struct ProductFeatures: Codable {
    let isPurchased: Int
    let isTrendy: Int
    let isFomo: Int
    let fomoMsg: String
    let isProductPerformance: Int
    let productPerformanceMsg: String

    enum CodingKeys: String, CodingKey {
        case isPurchased = "is_purchased"
        case isTrendy = "is_trendy"
        case isFomo = "is_fomo"
        case fomoMsg = "fomo_msg"
        case isProductPerformance = "is_product_performance"
        case productPerformanceMsg = "product_performance_msg"
    }
}

struct ConfigurableOption: Codable {
    let id: Int
    let label: String
    let position: Int
    let attributeCode: String
    let values: [OptionValue]
    let productId: Int

    enum CodingKeys: String, CodingKey {
        case id, label, position
        case attributeCode = "attribute_code"
        case values
        case productId = "product_id"
    }
}

struct OptionValue: Codable {
    let valueIndex: Int
    let label: String
    let swatchData: SwatchData

    enum CodingKeys: String, CodingKey {
        case valueIndex = "value_index"
        case label
        case swatchData = "swatch_data"
    }
}

struct SwatchData: Codable {
    let value: String
}

struct Variant: Codable {
    let product: VariantProduct
    let attributes: [VariantAttribute]
}

struct VariantProduct: Codable {
    let id: Int
    let name: String
    let sku: String
    let salableQty: Int
    let stockStatus: String
    let priceRange: PriceRange
    let approval: Int
    let weight: Int
    let mediaGallery: [ImageResource]?

    enum CodingKeys: String, CodingKey {
        case id, name, sku
        case salableQty = "salable_qty"
        case stockStatus = "stock_status"
        case priceRange = "price_range"
        case approval, weight
        case mediaGallery = "media_gallery"
    }
}

struct VariantAttribute: Codable {
    let uid: String
    let label: String
    let code: String
    let valueIndex: Int

    enum CodingKeys: String, CodingKey {
        case uid, label, code
        case valueIndex = "value_index"
    }
}
