//
//  ViewController.swift
//  EverLayout
//
//  Created by acrocat on 05/03/2017.
//  Copyright (c) 2017 acrocat. All rights reserved.
//

import UIKit
import EverLayout

class ViewController: UIViewController {
    var layout : EverLayout!
    
    let purpleSquare : UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layoutData = NSData(contentsOfFile: Bundle.main.path(forResource: "ViewController", ofType: "json", inDirectory: "Layouts")!)! as Data
        self.layout = EverLayout(layoutData: layoutData)
        self.layout.build(onView: self.view, viewEnvironment: self)
        
        self.purpleSquare.backgroundColor = .purple
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        self.layout.updateConstraints(withTraitColelction: newCollection)
    }
}

