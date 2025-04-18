//
//  AdditionalInformationCell.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 16/04/2025.
//

import UIKit

class AdditionalInformationCell: UITableViewCell {
    
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var attributeValue: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let identifier = "AdditionalInformationCell"
    
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
        containerView.layer.cornerRadius = 8
        
        // Setup labels
        attributeLabel.textAlignment = .right
        attributeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        attributeLabel.textColor = UIColor.darkGray
        attributeLabel.numberOfLines = 0
        
        attributeValue.textAlignment = .right
        attributeValue.font = UIFont.systemFont(ofSize: 14)
        attributeValue.textColor = UIColor.darkGray
        attributeValue.numberOfLines = 0
    }
    
    func configure(with attribute: ProductAttribute) {
        attributeLabel.text = attribute.label
        attributeValue.text = attribute.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        attributeLabel.text = nil
        attributeValue.text = nil
    }
}
