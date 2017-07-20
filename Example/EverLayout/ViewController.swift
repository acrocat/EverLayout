//
//  ViewController.swift
//  EverLayout
//
//  Created by acrocat on 05/03/2017.
//  Copyright (c) 2017 acrocat. All rights reserved.
//

import UIKit
import EverLayout

class ViewController: UIViewController , EverLayoutDelegate {
    var layout : EverLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load layout data
        let layoutData = try! Data(contentsOf: Bundle.main.url(forResource: "ViewController", withExtension: "json", subdirectory: "Layouts")!)
        self.layout = EverLayout(layoutData: layoutData)
        
        // Set delegate for layout build
        self.layout?.delegate = self
        
        // Build the layout
        self.layout?.build(onView: self.view, viewEnvironment: self)
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        // Update the layout for the new trait collection (apply constraints for different screen sizes)
        self.layout?.updateConstraints(withTraitColelction: newCollection)
    }
    
    /// This method is called every time the layout is built on the view. Use the method
    /// for things like: replacing placeholder content, calculating and updating constraints for
    /// dynamic content, creating a reference to views that only exist in the layout...
    ///
    /// - Parameters:
    ///   - layout: EverLayout that was built
    ///   - view: The view it was built on
    func layout(_ layout: EverLayout, didLoadOnView view: UIView) {
        // We're going to find a label that only exists in the layout and update its text
        if let myLabel = layout.viewIndex.view(forKey: "myLabel") as? UILabel {
            myLabel.text = "Hello, World... from the View Controller!"
        }
        
        // Next we're going target the label's wrapper and update its insets
        if let labelWrapper = layout.viewIndex.viewModel(forKey: "labelWrapper") {
            let newInset : CGFloat = 8
            
            labelWrapper.getConstraints(forAttributes: [.left]).forEach({ (constraint) in
                constraint.constant = newInset
            })
            labelWrapper.getConstraints(forAttributes: [.bottom,.right]).forEach({ (constraint) in
                constraint.constant = -newInset
            })
        }
    }
}

