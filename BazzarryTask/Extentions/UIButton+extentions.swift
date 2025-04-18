//
//  UIButton+extentions.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 16/04/2025.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
}
