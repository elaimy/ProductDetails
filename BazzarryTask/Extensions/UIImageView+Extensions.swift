//
//  UIImageView+Extensions.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 16/04/2025.
//

import UIKit

extension UIImageView {
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        // Set placeholder image if available
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        // Create URL from string
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        // Create URLSession task
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle errors
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            // Check for valid data
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data from URL: \(urlString)")
                return
            }
            
            // Update UI on main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        // Start the task
        task.resume()
    }
} 