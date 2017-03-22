//
//  TextFieldPropertyParser.swift
//  EverLayout
//
//  Created by Dale Webster on 22/03/2017.
//  Copyright © 2017 Dale Webster. All rights reserved.
//

import UIKit

class TextFieldPropertyResolver: PropertyResolver {
    override public var exposedProperties: [String : (String) -> Void] {
        var props = super.exposedProperties
        
        props["placeholder"] = {(source) in
            if let textField = self.view as? UITextField {
                textField.placeholder = PropertyResolver.string(value: source) ?? ""
            }
        }
        
        return props
    }
}

extension UITextField {
    override open func applyViewProperty(viewProperty: ELViewProperty) {
        super.applyViewProperty(viewProperty: viewProperty)
        
        TextFieldPropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
}
