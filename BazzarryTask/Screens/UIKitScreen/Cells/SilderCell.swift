//
//  SilderCell.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 16/04/2025.
//

import UIKit

class SilderCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Set up the image view
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
        productImage.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear the image when cell is reused
        productImage.image = nil
    }
}
