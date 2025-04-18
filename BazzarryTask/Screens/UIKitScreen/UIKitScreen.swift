//
//  UIKitScreen.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 16/04/2025.
//

import UIKit

class UIKitScreen: UIViewController {
    
    @IBOutlet weak var silderCollectionView: UICollectionView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var describtionLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productInfoLabel: UILabel!
    @IBOutlet weak var arriveInLabel: UILabel!
    @IBOutlet weak var inStockLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    // Segmented button outlets
    @IBOutlet weak var productDescButton: UIButton!
    @IBOutlet weak var additionalInfoButton: UIButton!
    @IBOutlet weak var customerReviewsButton: UIButton!
    
    // Content view outlets
    @IBOutlet weak var productDescView: UIView!
    @IBOutlet weak var additionalInfoView: UIView!
    @IBOutlet weak var customerReviewsView: UIView!
    
    
    @IBOutlet weak var reviewsView: UIView!
    
    // Selected button flag
    private var selectedSegmentIndex: Int = 0 // 0 = Product Desc, 1 = Additional Info, 2 = Customer Reviews
    
    private var products: [Product] = []
    private var imageURLs: [String] = []
    private var colorOptions: [OptionValue] = []
    private var selectedColorIndex: Int = 0
    private var autoScrollTimer: Timer?
    
    // Data arrays for different tabs
    private var productDescItems: [String] = []
    private var additionalInfoItems: [(title: String, description: String)] = []
    private var customerReviewItems: [String] = []
    
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    // Add a flag to track current background color state
    private var isLightBlueBackground = true
    
    // Additional data arrays
    private var productAttributes: [ProductAttribute] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupPageControl()
        setupNavigationButtons()
        setupSegmentedButtons()
        setupTableView()
        setupTableContainer()
        loadProductData()
        
        // Initially hide the reviews view since we start with selectedSegmentIndex = 0
        reviewsView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAutoScrollTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAutoScrollTimer()
    }
    
    // MARK: - Button Actions
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        navigateToPage(direction: .previous)
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        navigateToPage(direction: .next)
    }
    
    @IBAction func dismiss(_ sender: UIButton){
        dismiss(animated: true)
    }
    
    // Navigation direction enum
    private enum NavigationDirection {
        case next
        case previous
    }
    
    // Navigate slider in the specified direction
    private func navigateToPage(direction: NavigationDirection) {
        guard !imageURLs.isEmpty else { return }
        
        // Stop auto scroll timer when manually navigating
        stopAutoScrollTimer()
        
        // Calculate the target page
        var targetPage = pageControl.currentPage
        
        switch direction {
        case .next:
            targetPage = (targetPage + 1) % imageURLs.count
        case .previous:
            targetPage = (targetPage - 1 + imageURLs.count) % imageURLs.count
        }
        
        // Update page control
        pageControl.currentPage = targetPage
        
        // Scroll to the target page
        let indexPath = IndexPath(item: targetPage, section: 0)
        silderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // Update product information if needed
        if !products.isEmpty {
            updateProductLabels(with: products[0]) // Always using the first product for now
        }
        
        // Restart the auto-scroll timer
        startAutoScrollTimer()
    }
    
    private func startAutoScrollTimer() {
        // Cancel any existing timer
        stopAutoScrollTimer()
        
        // Create a new timer that scrolls every 3 seconds
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    @objc private func scrollToNextPage() {
        navigateToPage(direction: .next)
    }
    
    private func setupPageControl() {
        // Configure the existing page control from XIB
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.4, green: 0.345, blue: 0.796, alpha: 1.0)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Add target for page control taps
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        // Scroll to the page that was tapped
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        silderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // Restart the auto-scroll timer
        startAutoScrollTimer()
    }
    
    private func setupNavigationButtons() {
        // Style left button
        leftButton.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        leftButton.layer.cornerRadius = leftButton.bounds.height / 2
        leftButton.tintColor = UIColor(red: 0.4, green: 0.345, blue: 0.796, alpha: 1.0)
        
        // Style right button
        rightButton.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        rightButton.layer.cornerRadius = rightButton.bounds.height / 2
        rightButton.tintColor = UIColor(red: 0.4, green: 0.345, blue: 0.796, alpha: 1.0)
        
        // Add shadow for better visibility
        [leftButton, rightButton].forEach { button in
            button?.layer.shadowColor = UIColor.black.cgColor
            button?.layer.shadowOffset = CGSize(width: 0, height: 1)
            button?.layer.shadowOpacity = 0.3
            button?.layer.shadowRadius = 2
        }
    }
    
    // MARK: - Setup Table Container
    private func setupTableContainer() {
        // Configure the container view with border and corner radius
        tableContainerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        tableContainerView.layer.borderWidth = 1
        tableContainerView.layer.cornerRadius = 16
    }
    
    // MARK: - TableView Setup
    private func setupTableView() {
        // Register the cells
        tableView.register(UINib(nibName: "ProductDescriptionCell", bundle: nil), forCellReuseIdentifier: ProductDescriptionCell.identifier)
        tableView.register(UINib(nibName: "AdditionalInformationCell", bundle: nil), forCellReuseIdentifier: AdditionalInformationCell.identifier)
        
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Remove default separators
        tableView.separatorStyle = .none
        
        // Set estimated row height for automatic dimension
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Make the table view background transparent
        tableView.backgroundColor = .clear
        
        // Disable scrolling in the table view (since we're using a scroll view)
        tableView.isScrollEnabled = false
        
        // Start with light blue background for first row
        isLightBlueBackground = true
    }
    
    // MARK: - Segmented Buttons Setup
    private func setupSegmentedButtons() {
        // Configure button appearance
        [productDescButton, additionalInfoButton, customerReviewsButton].forEach { button in
            // Create a thin bottom border for each button as a background initially
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0, y: button!.frame.size.height - 1, width: button!.frame.width, height: 1)
            bottomBorder.backgroundColor = UIColor.lightGray.cgColor
            button?.layer.addSublayer(bottomBorder)
            
            // Add action for button taps
            button?.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
        }
        
        // Set initial selection (right button)
        selectedSegmentIndex = 0
        updateSegmentedButtons()
    }
    
    @objc private func segmentButtonTapped(_ sender: UIButton) {
        // Determine which button was tapped
        if sender == productDescButton {
            selectedSegmentIndex = 0
            // Reset background state when switching to product description
            isLightBlueBackground = true
        } else if sender == additionalInfoButton {
            selectedSegmentIndex = 1
        } else if sender == customerReviewsButton {
            selectedSegmentIndex = 2
        }
        
        // Update UI based on selection
        updateSegmentedButtons()
        
        // Reload table view to show different content and update height
        reloadTableAndUpdateHeight()
    }
    
    private func updateSegmentedButtons() {
        // Update button appearance
        productDescButton.setTitleColor(selectedSegmentIndex == 0 ? .black : .darkGray, for: .normal)
        additionalInfoButton.setTitleColor(selectedSegmentIndex == 1 ? .black : .darkGray, for: .normal)
        customerReviewsButton.setTitleColor(selectedSegmentIndex == 2 ? .black : .darkGray, for: .normal)
        
        // Update button borders
        updateButtonBorders()
        
        // Show/hide the content views
        productDescView.isHidden = selectedSegmentIndex != 0
        additionalInfoView.isHidden = selectedSegmentIndex != 1
        customerReviewsView.isHidden = selectedSegmentIndex != 2
        
        // Control visibility of reviewsView based on selected segment
        reviewsView.isHidden = selectedSegmentIndex != 2
    }
    
    private func updateButtonBorders() {
        // Update the bottom border of each button
        if let sublayers = productDescButton.layer.sublayers, sublayers.count > 0 {
            for layer in sublayers where layer.frame.height == 1 || layer.frame.height == 2 {
                layer.frame = CGRect(x: 0, y: productDescButton.frame.size.height - (selectedSegmentIndex == 0 ? 2 : 1), 
                                    width: productDescButton.frame.width, 
                                    height: selectedSegmentIndex == 0 ? 2 : 1)
                layer.backgroundColor = (selectedSegmentIndex == 0 ? UIColor.black : UIColor.lightGray).cgColor
            }
        }
        
        if let sublayers = additionalInfoButton.layer.sublayers, sublayers.count > 0 {
            for layer in sublayers where layer.frame.height == 1 || layer.frame.height == 2 {
                layer.frame = CGRect(x: 0, y: additionalInfoButton.frame.size.height - (selectedSegmentIndex == 1 ? 2 : 1), 
                                    width: additionalInfoButton.frame.width, 
                                    height: selectedSegmentIndex == 1 ? 2 : 1)
                layer.backgroundColor = (selectedSegmentIndex == 1 ? UIColor.black : UIColor.lightGray).cgColor
            }
        }
        
        if let sublayers = customerReviewsButton.layer.sublayers, sublayers.count > 0 {
            for layer in sublayers where layer.frame.height == 1 || layer.frame.height == 2 {
                layer.frame = CGRect(x: 0, y: customerReviewsButton.frame.size.height - (selectedSegmentIndex == 2 ? 2 : 1), 
                                    width: customerReviewsButton.frame.width, 
                                    height: selectedSegmentIndex == 2 ? 2 : 1)
                layer.backgroundColor = (selectedSegmentIndex == 2 ? UIColor.black : UIColor.lightGray).cgColor
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update button borders after layout
        updateButtonBorders()
        
        // Update table view height
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        // Calculate the content height
        tableView.layoutIfNeeded()
        
        // Get the height of the content
        let contentHeight = tableView.contentSize.height
        
        // Update the height constraint
        tableViewHeightConstraint.constant = contentHeight
        
        // Force layout update
        view.layoutIfNeeded()
    }
    
    // Add observer for table content size changes
    func reloadTableAndUpdateHeight() {
        tableView.reloadData()
        
        // Update height after a small delay to ensure the table view content size is calculated
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateTableViewHeight()
        }
    }
    
    // MARK: - Debug Helper
    private func printDebugInfo() {
        print("Product Description Items: \(productDescItems.count)")
        for (index, item) in productDescItems.enumerated() {
            print("Item \(index): \(item.prefix(30))... contains &nbsp;: \(item.contains("&nbsp;"))")
        }
    }
    
    // MARK: - Data Loading
    private func loadProductData() {
        guard let jsonData = readLocalJSONFile(forName: "response") else {
            print("Failed to load JSON file")
            return
        }
        
        // Add debug parsing to pinpoint issues
        debugParseJSON(jsonData)
        
        do {
            let productResponse = try JSONDecoder().decode(ProductResponse.self, from: jsonData)
            
            // Get all product items
            self.products = productResponse.data.products.items
            
            // Extract image URLs from the first product for the slider
            if let firstProduct = products.first {
                // Get image URLs from media gallery
                self.imageURLs = firstProduct.mediaGallery.map { $0.url }
                
                // Extract color options
                for option in firstProduct.configurableOptions {
                    if option.attributeCode.lowercased() == "color" {
                        self.colorOptions = option.values
                        
                        // Debug print to check color values
                        print("Found \(self.colorOptions.count) color options:")
                        for (index, color) in self.colorOptions.enumerated() {
                            print("Color \(index): \(color.label), Value: \(color.swatchData.value)")
                        }
                        
                        // Set initial color label if colors exist
                        if !self.colorOptions.isEmpty {
                            DispatchQueue.main.async {
                                self.updateColorLabel(with: self.colorOptions[0].label)
                            }
                        }
                        
                        break
                    }
                }
                
                // Extract product description
                let htmlDescription = firstProduct.productDescription.html
                print("Original HTML Description: \(htmlDescription.prefix(300))...")
                
                // Check for &nbsp; or equivalent in the HTML
                print("Contains &nbsp;: \(htmlDescription.contains("&nbsp;"))")
                print("Contains  : \(htmlDescription.contains(" "))")
                
                // Try different approach for cleaning HTML
                let plainDescription = htmlDescription
                    .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    .replacingOccurrences(of: "&nbsp;", with: "§MARKER§") // Replace with a unique marker
                
                print("Plain Description with markers: \(plainDescription.prefix(300))...")
                
                // Split the description into paragraphs
                var paragraphs = plainDescription.components(separatedBy: "\n")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                
                // Process paragraphs to handle marker
                self.productDescItems = []
                for paragraph in paragraphs {
                    if paragraph.contains("§MARKER§") {
                        // Add the paragraph with the marker intact (will be processed in cellForRowAt)
                        self.productDescItems.append(paragraph)
                    } else {
                        // Add paragraph as is
                        self.productDescItems.append(paragraph)
                    }
                }
                
                // Print debug info
                printDebugInfo()
                
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
                
                // Update UI on the main thread
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    // Update page control
                    self.pageControl.numberOfPages = self.imageURLs.count
                    self.pageControl.currentPage = 0
                    
                    // Update collection views
                    self.silderCollectionView.reloadData()
                    self.colorsCollectionView.reloadData()
                    
                    // Update product information labels
                    self.updateProductLabels(with: firstProduct)
                    
                    // Update table view and its height
                    self.reloadTableAndUpdateHeight()
                }
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    // Update product name and description labels with product data
    private func updateProductLabels(with product: Product) {
        // Set product name label
        productNameLabel.text = product.name
        
        // Set description label
        describtionLabel.text = product.name
        
        // Set product info label with SKU code
        productInfoLabel.text = "كود المنتج: \(product.sku) - البائع:"
        
        // Set arrival information from shipTo data
        arriveInLabel.text = "\(product.shipTo.period)"
        
        // Set stock status information
        let stockStatus = product.stockStatus == "IN_STOCK" ? "متوفر في المخزن" : "غير متوفر"
        inStockLabel.text = "\(stockStatus)"
    }
    
    // Debug helper to pinpoint JSON parsing issues
    private func debugParseJSON(_ jsonData: Data) {
        // Try parsing just the root structure
        do {
            // Check if we can parse the root level
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            print("Root level parsed successfully")
            
            // Try to access the data portion
            if let data = json?["data"] as? [String: Any] {
                print("Data level parsed successfully")
                
                // Try to access the products portion
                if let products = data["products"] as? [String: Any] {
                    print("Products level parsed successfully")
                    
                    // Try to access the items array
                    if let items = products["items"] as? [[String: Any]], let firstItem = items.first {
                        print("Items level parsed successfully, found \(items.count) items")
                        
                        // Check if ship_to exists in the first product
                        if let shipTo = firstItem["ship_to"] as? [String: Any] {
                            print("ship_to key exists and contains: \(shipTo)")
                        } else {
                            print("⚠️ ship_to key missing or invalid in product")
                            // Print all available keys to find the right format
                            print("Available keys in first product: \(firstItem.keys.joined(separator: ", "))")
                        }
                    }
                }
            }
        } catch {
            print("Error in debug JSON parsing: \(error)")
        }
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

// MARK: - Collection View Setup
extension UIKitScreen {
    private func setupCollectionView() {
        // Setup slider collection view
        silderCollectionView.delegate = self
        silderCollectionView.dataSource = self
        
        // Register slider cell
        silderCollectionView.register(UINib(nibName: "SilderCell", bundle: nil), forCellWithReuseIdentifier: "SilderCell")
        
        // Configure slider layout
        if let flowLayout = silderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
        
        // Enable paging for slider
        silderCollectionView.isPagingEnabled = true
        silderCollectionView.showsHorizontalScrollIndicator = false
        
        // Setup colors collection view
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        
        // Register color cell
        colorsCollectionView.register(UINib(nibName: "ColorsCell", bundle: nil), forCellWithReuseIdentifier: "ColorsCell")
        
        // Configure colors layout
        if let flowLayout = colorsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.itemSize = CGSize(width: 32, height: 32)
        }
        
        colorsCollectionView.showsHorizontalScrollIndicator = false
        
        // Set colors collection view to display right-to-left
        colorsCollectionView.semanticContentAttribute = .forceRightToLeft
        
        // If needed, we can also transform the collection view for RTL
        // colorsCollectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension UIKitScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == silderCollectionView {
            return imageURLs.count
        } else if collectionView == colorsCollectionView {
            return colorOptions.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == silderCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SilderCell", for: indexPath) as? SilderCell else {
                return UICollectionViewCell()
            }
            
            // Configure cell with image URL
            let imageUrl = imageURLs[indexPath.item]
            cell.productImage.loadImage(from: imageUrl)
            
            return cell
        } else if collectionView == colorsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCell", for: indexPath) as? ColorsCell else {
                return UICollectionViewCell()
            }
            
            // Configure cell with color option
            let colorOption = colorOptions[indexPath.item]
            cell.configure(with: colorOption)
            
            // Highlight selected color
            if indexPath.item == selectedColorIndex {
                cell.contentView.layer.borderWidth = 2.0
                cell.contentView.layer.borderColor = UIColor(red: 0.4, green: 0.345, blue: 0.796, alpha: 1.0).cgColor
                cell.contentView.layer.cornerRadius = cell.bounds.width / 2
            } else {
                cell.contentView.layer.borderWidth = 0
                cell.contentView.layer.borderColor = nil
            }
            
            // If using transform method, we need to flip each cell back
            // cell.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorsCollectionView {
            // Update selected color index
            selectedColorIndex = indexPath.item
            
            // Reload colors collection view to update selection
            colorsCollectionView.reloadData()
            
            // Update product details for the selected color if needed
            if !products.isEmpty && !colorOptions.isEmpty {
                let colorOption = colorOptions[indexPath.item]
                
                // Update color label with selected color
                updateColorLabel(with: colorOption.label)
                
                // Find the variant with this color
                if let product = products.first, let variant = findVariantWithColor(product: product, colorValueIndex: colorOption.valueIndex) {
                    // Update product information with variant data
                    updateProductWithVariant(variant: variant)
                }
            }
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
    
    private func updateProductWithVariant(variant: Variant) {
        // Update product info with the variant data
        productNameLabel.text = variant.product.name
        
        // Update SKU
        let skuText = "كود المنتج: \(variant.product.sku) - البائع:"
        productInfoLabel.text = skuText
        
        // Update stock status
        let stockStatus = variant.product.stockStatus == "IN_STOCK" ? "متوفر في المخزن" : "غير متوفر"
        inStockLabel.text = "\(stockStatus)"
        
        // Update image gallery if the variant has its own images
        if let variantImages = variant.product.mediaGallery, !variantImages.isEmpty {
            imageURLs = variantImages.map { $0.url }
            pageControl.numberOfPages = imageURLs.count
            pageControl.currentPage = 0
            silderCollectionView.reloadData()
        }
    }
    
    private func updateColorLabel(with colorName: String) {
        // Set color label text in Arabic format: "اللون [color]"
        colorLabel.text = "اللون \(colorName)"
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UIKitScreen: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == silderCollectionView {
            // Make cell size exactly match the collection view size for proper paging
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
        // For colors collection view, use the layout's itemSize
        return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? CGSize(width: 32, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == silderCollectionView {
            // No insets to ensure proper paging
            return UIEdgeInsets.zero
        }
        // For colors collection view, add some padding
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == silderCollectionView {
            // No spacing between pages
            return 0
        }
        // For colors collection view, use the layout's value
        return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == silderCollectionView {
            // No spacing between items
            return 0
        }
        // For colors collection view, use the layout's value
        return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 5
    }
}

// MARK: - UIScrollViewDelegate
extension UIKitScreen {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Only handle slider collection view scroll
        if scrollView == silderCollectionView {
            // Only update during user scrolling to avoid conflicts with programmatic scrolling
            if scrollView.isDragging || scrollView.isDecelerating {
                let pageWidth = scrollView.frame.width
                let currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
                
                // Ensure currentPage is within bounds
                if currentPage >= 0 && currentPage < imageURLs.count {
                    pageControl.currentPage = currentPage
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Only handle slider collection view
        if scrollView == silderCollectionView {
            // Pause auto-scrolling when user starts scrolling manually
            stopAutoScrollTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Only handle slider collection view
        if scrollView == silderCollectionView {
            // Resume auto-scrolling when scrolling comes to rest
            startAutoScrollTimer()
            
            // Update page control when scroll finishes
            let pageWidth = scrollView.frame.width
            let currentPage = Int(floor(scrollView.contentOffset.x / pageWidth))
            
            // Ensure currentPage is within bounds
            if currentPage >= 0 && currentPage < imageURLs.count {
                pageControl.currentPage = currentPage
                
                // Update product information based on current page
                if !products.isEmpty && currentPage < products.count {
                    updateProductLabels(with: products[0]) // We're always using the first product for now
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Only handle slider collection view
        if scrollView == silderCollectionView {
            if !decelerate {
                // Resume auto-scrolling only if not decelerating
                startAutoScrollTimer()
                
                // Update page control when scroll finishes without deceleration
                let pageWidth = scrollView.frame.width
                let currentPage = Int(floor(scrollView.contentOffset.x / pageWidth))
                
                // Ensure currentPage is within bounds
                if currentPage >= 0 && currentPage < imageURLs.count {
                    pageControl.currentPage = currentPage
                    
                    // Update product information based on current page
                    if !products.isEmpty && currentPage < products.count {
                        updateProductLabels(with: products[0]) // We're always using the first product for now
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UIKitScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegmentIndex {
        case 0:
            return productDescItems.count
        case 1:
            return additionalInfoItems.count
        case 2:
            return customerReviewItems.count
        case 3:
            return productAttributes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedSegmentIndex {
        case 0, 1, 2:
            // Existing cases for product description, additional info, and customer reviews
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductDescriptionCell.identifier, for: indexPath) as? ProductDescriptionCell else {
                return UITableViewCell()
            }
            
            // Configure cell based on selected segment
            switch selectedSegmentIndex {
            case 0:
                // Product description cell
                let description = productDescItems[indexPath.row]
                cell.configure(title: description)
                
                // Explicitly set background colors based on content or position
                switch indexPath.row {
                case 0:
                    // First row is always light blue
                    cell.containerView.backgroundColor = UIColor(hexString: "F1FCFE")
                case 1, 2:
                    // These rows are white
                    cell.containerView.backgroundColor = UIColor.white
                case 3, 4, 5, 6, 7:
                    // These rows are light blue
                    cell.containerView.backgroundColor = UIColor(hexString: "F1FCFE")
                default:
                    // Fallback to alternating colors
                    cell.containerView.backgroundColor = indexPath.row % 2 == 0 ? 
                        UIColor(hexString: "F1FCFE") : UIColor.white
                }
                
                // Check if this row contains &nbsp; and toggle background
                if description.contains("&nbsp;") {
                    // This row contains the marker, toggle the background state
                    isLightBlueBackground = !isLightBlueBackground
                    
                    // Remove &nbsp; from displayed text
                    let cleanText = description.replacingOccurrences(of: "&nbsp;", with: "")
                    cell.configure(title: cleanText)
                }
                
            case 1:
                // Additional info cell
                let item = additionalInfoItems[indexPath.row]
                cell.configure(title: "\(item.title): \(item.description)")
                
                // All cells are white for additional info
                cell.containerView.backgroundColor = UIColor.white
                
            case 2:
                // Customer reviews cell
                let review = customerReviewItems[indexPath.row]
                cell.configure(title: review)
                
                // Use alternating colors for reviews
                cell.containerView.backgroundColor = indexPath.row % 2 == 0 ? 
                    UIColor(hexString: "F1FCFE") : UIColor.white
                
            default:
                break
            }
            
            // Remove selection style
            cell.selectionStyle = .none
            
            // Make cell background transparent
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
            return cell
            
        case 3:
            // Use AdditionalInformationCell for product attributes
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalInformationCell.identifier, for: indexPath) as? AdditionalInformationCell else {
                return UITableViewCell()
            }
            
            // Get attribute data
            let attribute = productAttributes[indexPath.row]
            cell.configure(with: attribute)
            
            // Apply alternating background colors
            cell.containerView.backgroundColor = indexPath.row % 2 == 0 ? 
                UIColor(hexString: "F1FCFE") : UIColor.white
            
            // Remove selection style
            cell.selectionStyle = .none
            
            // Make cell background transparent
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
