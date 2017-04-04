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
    override open var settableProperties: [String : (String) -> Void] {
        var props = super.settableProperties
        
        props["text"] = {[weak self] source in
            if let view = self?.view as? TextMappable {
                view.mapText(source)
            }
        }
        props["textColor"] = {[weak self] source in
            if let view = self?.view as? TextColorMappable {
                view.mapTextColor(source)
            }
        }
        props["backgroundImage"] = {[weak self] source in
            if let view = self?.view as? BackgroundImageMappable {
                view.mapBackgroundImage(source)
            }
        }
        props["image"] = {[weak self] source in
            if let view = self?.view as? ImageMappable {
                view.mapImage(source)
            }
        }
        
        return props
    }
    
    override var retrievableProperties: [String : () -> String?] {
        var props = super.retrievableProperties
        
        props["text"] = {[weak self] in
            guard let view = self?.view as? TextMappable else { return nil }
            
            return view.getMappedText()
        }
        props["textColor"] = {[weak self] in
            guard let view = self?.view as? TextColorMappable else { return nil }
            
            return view.getMappedTextColor()
        }
        
        return props
    }
}

extension UIButton {
    override open func applyViewProperty(viewProperty: ELViewProperty){
        super.applyViewProperty(viewProperty: viewProperty)
        
        ButtonPropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
}
