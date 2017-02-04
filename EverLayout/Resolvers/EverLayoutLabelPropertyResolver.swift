//
//  EverLayoutLabelPropertyResolver.swift
//  EverLayout
//
//  Created by Dale Webster on 02/02/2017.
//  Copyright © 2017 TabApps. All rights reserved.
//

import UIKit

class EverLayoutLabelPropertyResolver: EverLayoutPropertyResolver
{
    // ---------------------------------------------------------------------------
    // MARK: - Enum Mapping
    // ---------------------------------------------------------------------------
    
    private static let LINE_BREAK_MODE_KEYS : [String] = [
        "byWordWrapping",
        "byCharWrapping",
        "byClipping",
        "byTruncatingHead",
        "byTruncatingTail",
        "byTruncatingMiddle"
    ]
    private static let TEXT_ALIGNMENT_KEYS : [String] = [
        "left",
        "center",
        "right",
        "justified",
        "natural"
    ]
    
    // ---------------------------------------------------------------------------
    // ---------------------------------------------------------------------------
    
    override var exposedProperties: [String : (String) -> Void] {
        var props = super.exposedProperties
        
        props["text"] = {source in
            if let label = self.view as? UILabel
            {
                label.text = EverLayoutPropertyResolver.string(value: source)
            }
        }
        props["textColor"] = {source in
            if let label = self.view as? UILabel
            {
                label.textColor = EverLayoutPropertyResolver.color(value: source)
            }
        }
        props["lineBreakMode"] = {source in
            if let label = self.view as? UILabel
            {
                label.lineBreakMode = EverLayoutLabelPropertyResolver.lineBreakMode(source: source) ?? .byTruncatingTail
            }
        }
        props["textAlignment"] = {source in
            if let label = self.view as? UILabel
            {
                label.textAlignment = EverLayoutLabelPropertyResolver.textAlignment(source: source) ?? .left
            }
        }
        props["numberOfLines"] = {source in
            if let label = self.view as? UILabel
            {
                label.numberOfLines = Int(EverLayoutPropertyResolver.number(value: source) ?? 1)
            }
        }
        props["fontSize"] = {source in
            if let label = self.view as? UILabel
            {
                label.font = label.font.withSize(EverLayoutPropertyResolver.number(value: source) ?? UIFont.systemFontSize)
            }
        }
        
        return props
    }
    
    static func lineBreakMode (source : String) -> NSLineBreakMode?
    {
        guard let index = self.LINE_BREAK_MODE_KEYS.index(of: source) else { return nil }
        
        return NSLineBreakMode(rawValue: index)
    }
    
    static func textAlignment (source : String) -> NSTextAlignment?
    {
        guard let index = self.TEXT_ALIGNMENT_KEYS.index(of: source) else { return nil }
        
        return NSTextAlignment(rawValue: index)
    }
}

extension UILabel
{
    override open func applyViewProperty(viewProperty: EverLayoutViewProperty)
    {
        super.applyViewProperty(viewProperty: viewProperty)
        
        EverLayoutLabelPropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
}
