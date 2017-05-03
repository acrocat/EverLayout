//
//  TextFieldPropertyParser.swift
//  EverLayout
//
//  Created by Dale Webster on 22/03/2017.
//  Copyright © 2017 Dale Webster. All rights reserved.
//

import UIKit

class TextFieldPropertyResolver: PropertyResolver {
    override public var settableProperties: [String : (String) -> Void] {
        var props = super.settableProperties
        
        props["placeholder"] = {[weak self] (source) in
            if let view = self?.view as? PlaceholderMappable {
                view.mapPlaceholder(source)
            }
        }
        
        return props
    }
    
    override var retrievableProperties: [String : () -> String?] {
        var props = super.retrievableProperties
        
        props["placeholder"] = {[weak self] in
            guard let view = self?.view as? PlaceholderMappable else { return nil }
            
            return view.getMappedPlaceholder()
        }
        
        return props
    }
}

extension UITextField {
    override open func applyViewProperty(viewProperty: ELViewProperty) {
        super.applyViewProperty(viewProperty: viewProperty)
        
        TextFieldPropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
    
    open override func retrieveViewProperty(viewProperty: ELViewProperty) -> String? {
        return TextFieldPropertyResolver(view: self).retrieve(viewProperty: viewProperty)
    }
}
