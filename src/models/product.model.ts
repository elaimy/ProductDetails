// Price related interfaces
interface Price {
  currency: string;
  value: number;
}

interface PriceBase {
  currency: string;
  value: number;
}

interface Discount {
  amount_off: number;
  percent_off: number;
}

interface PriceRange {
  regular_price: Price;
  regular_price_base: PriceBase;
  final_price: Price;
  final_price_base: PriceBase;
  discount: Discount;
  discount_base: Discount;
}

// Media related interfaces
interface MediaGalleryItem {
  url: string;
}

// Category interface
interface Category {
  id: number;
  name: string;
}

// Attribute interface
interface Attribute {
  label: string;
  code: string;
  value: string;
}

// Vendor info interface
interface VendorInfo {
  vendor_id: number;
  products_count: string;
  joined_date: string;
  vendor_region_name: string;
  vendor_country: string;
  store_name: string | null;
  logo_url: string;
}

// Product features interface
interface ProductFeatures {
  is_purchased: number;
  is_trendy: number;
  is_fomo: number;
  fomo_msg: string;
  is_product_performance: number;
  product_performance_msg: string;
}

// Configurable option value interface
interface ConfigurableOptionValue {
  value_index: number;
  label: string;
  swatch_data: {
    value: string;
  };
}

// Configurable option interface
interface ConfigurableOption {
  id: number;
  label: string;
  position: number;
  attribute_code: string;
  values: ConfigurableOptionValue[];
  product_id: number;
}

// Variant attribute interface
interface VariantAttribute {
  uid: string;
  label: string;
  code: string;
  value_index: number;
}

// Variant product interface
interface VariantProduct {
  id: number;
  name: string;
  sku: string;
  salable_qty: number;
  stock_status: string;
  price_range: {
    maximum_price: PriceRange;
    minimum_price: PriceRange;
  };
  media_gallery: MediaGalleryItem[];
  approval: number;
  weight: number;
}

// Variant interface
interface Variant {
  product: VariantProduct;
  attributes: VariantAttribute[];
}

// Main Product interface
export interface Product {
  salable_qty: number;
  stock_status: string;
  id: number;
  name: string;
  sku: string;
  type_id: string;
  approval: number;
  ship_to: {
    prefix: string;
    icon: string;
    period: string;
  };
  labels: {
    title: string;
    label_text: string;
    label_image: string | null;
    background_image: string | null;
    custom_style: string | null;
  }[];
  description: {
    html: string;
  };
  small_image: {
    url: string;
  };
  url_rewrites: {
    url: string;
  }[];
  price_range: {
    maximum_price: PriceRange;
    minimum_price: PriceRange;
  };
  categories: Category[];
  media_gallery: MediaGalleryItem[];
  rating_summary: number;
  review_count: number;
  review_availability: number;
  reviews: {
    items: any[];
  };
  attributes: Attribute[];
  vendorInfo: VendorInfo;
  product_features: ProductFeatures;
  configurable_options: ConfigurableOption[];
  variants: Variant[];
}

// Response interface
export interface ProductResponse {
  data: {
    products: {
      items: Product[];
    };
  };
} 