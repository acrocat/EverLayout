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
    var layout : EverLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layoutData = NSData(contentsOfFile: Bundle.main.path(forResource: "ViewController", ofType: "json", inDirectory: "Layouts")!)! as Data
        self.layout = EverLayout(layoutData: layoutData)
        self.layout.delegate = self
        self.layout.build(onView: self.view, viewEnvironment: self)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    func layout(_ layout: EverLayout, didLoadOnView view: UIView) {
        
    }
}

