//
//  ColorsCell.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 16/04/2025.
//

import UIKit

class ColorsCell: UICollectionViewCell {
    
    @IBOutlet weak var viewColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Make the color view circular
        viewColor.layer.cornerRadius = viewColor.bounds.width / 2
        viewColor.clipsToBounds = true
        
        // Add a border to make colors more visible
        viewColor.layer.borderWidth = 1.0
        viewColor.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configure(with colorOption: OptionValue) {
        // Set the color view's background color based on the hex value
        let colorHex = colorOption.swatchData.value
        if !colorHex.isEmpty {
            viewColor.backgroundColor = UIColor(hexString: colorHex)
        } else {
            // Fallback color if no hex value
            viewColor.backgroundColor = .gray
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewColor.backgroundColor = nil
    }
}
