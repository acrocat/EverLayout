//
//  EverLayoutButtonPropertyResolver.swift
//  EverLayout
//
//  Created by Dale Webster on 02/02/2017.
//  Copyright © 2017 TabApps. All rights reserved.
//

import UIKit

class EverLayoutButtonPropertyResolver: EverLayoutPropertyResolver
{
    override open var exposedProperties: [String : (String) -> Void] {
        var props = super.exposedProperties
        
        props["text"] = {source in
            if let button = self.view as? UIButton
            {
                button.setTitle(EverLayoutPropertyResolver.string(value: source) ?? "", for: .normal)
            }
        }
        props["textColor"] = {source in
            if let button = self.view as? UIButton
            {
                button.setTitleColor(EverLayoutPropertyResolver.color(value: source) ?? .black, for: .normal)
            }
        }
        
        return props
    }
}

extension UIButton
{
    override open func applyViewProperty(viewProperty: EverLayoutViewProperty)
    {
        super.applyViewProperty(viewProperty: viewProperty)
        
        EverLayoutButtonPropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
}
