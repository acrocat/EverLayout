//
//  EverLayoutButtonPropertyResolver.swift
//  EverLayout
//
//  Created by Dale Webster on 02/02/2017.
//  Copyright © 2017 TabApps. All rights reserved.
//

import UIKit

class ButtonPropertyResolver: PropertyResolver
{
    override open var exposedProperties: [String : (String) -> Void] {
        var props = super.exposedProperties
        
        props["text"] = {source in
            if let button = self.view as? UIButton
            {
                button.setTitle(PropertyResolver.string(value: source) ?? "", for: .normal)
            }
        }
        props["textColor"] = {source in
            if let button = self.view as? UIButton
            {
                button.setTitleColor(PropertyResolver.color(value: source) ?? .black, for: .normal)
            }
        }
        props["backgroundImage"] = {source in
            if let button = self.view as? UIButton
            {
                button.setBackgroundImage(ImageViewPropertyResolver.image(source: source), for: .normal)
            }
        }
        props["image"] = {source in
            if let button = self.view as? UIButton
            {
                button.setImage(ImageViewPropertyResolver.image(source: source), for: .normal)
            }
        }
        
        return props
    }
}

extension UIButton
{
    override open func applyViewProperty(viewProperty: ELViewProperty)
    {
        super.applyViewProperty(viewProperty: viewProperty)
        
        ButtonPropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
}
