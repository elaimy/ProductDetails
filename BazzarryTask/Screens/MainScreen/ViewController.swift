//
//  ViewController.swift
//  BazzarryTask
//
//  Created by Ahmed Elelaimy on 16/04/2025.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func UIKitButton(_ sender: Any) {
        let vc = UIKitScreen()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func SwiftUIButton(_ sender: Any) {
        // Create a SwiftUI view
        let swiftUIView = SwiftUIView()
        
        // Wrap the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.modalPresentationStyle = .fullScreen
        
        // Present the hosting controller
        self.present(hostingController, animated: true)
    }
    
}

