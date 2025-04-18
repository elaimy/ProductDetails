//
//  ProductDescriptionCell.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 16/04/2025.
//

import UIKit

class ProductDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let identifier = "ProductDescriptionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Make the background transparent
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Setup container view
        containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        containerView.layer.borderWidth = 1
        containerView.backgroundColor = UIColor(red: 245/255, green: 250/255, blue: 252/255, alpha: 1.0) // Light blue tint
        
        // Setup labels
        titleLabel.textAlignment = .right
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.numberOfLines = 0
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
