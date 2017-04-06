//
//  EverLayoutLabelPropertyResolver.swift
//  EverLayout
//
//  Created by Dale Webster on 02/02/2017.
//  Copyright © 2017 TabApps. All rights reserved.
//

import UIKit

class LabelPropertyResolver: PropertyResolver
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
    
    override var settableProperties: [String : (String) -> Void] {
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
        props["lineBreakMode"] = {[weak self] source in
            if let view = self?.view as? LineBreakModeMappable {
                view.mapLineBreakMode(source)
            }
        }
        props["textAlignment"] = {[weak self] source in
            if let view = self?.view as? TextAlignmentMappable {
                view.mapTextAlignment(source)
            }
        }
        props["numberOfLines"] = {[weak self] source in
            if let view = self?.view as? NumberOfLinesMappable {
                view.mapNumberOfLines(source)
            }
        }
        props["fontSize"] = {[weak self] source in
            if let view = self?.view as? FontSizeMappable {
                view.mapFontSize(source)
            }
        }
        
        return props
    }
    
    override var retrievableProperties: [String : () -> String?] {
        var props = super.retrievableProperties
        
        props["tetx"] = {[weak self] in
            guard let view  = self?.view as? TextMappable else { return nil }
            
            return view.getMappedText()
        }
        props["textColor"] = {[weak self] in
            guard let view = self?.view as? TextColorMappable else { return nil }
            
            return view.getMappedTextColor()
        }
        props["lineBreakMode"] = {[weak self] in
            guard let view = self?.view as? LineBreakModeMappable else { return nil }
            
            return view.getMappedLineBreakMode()
        }
        props["textAlignment"] = {[weak self] in
            guard let view = self?.view as? TextAlignmentMappable else { return nil }
            
            return view.getMappedTextAlignment()
        }
        props["numberOfLines"] = {[weak self] in
            guard let view = self?.view as? NumberOfLinesMappable else { return nil }
            
            return view.getMappedNumberOfLines()
        }
        props["fontSize"] = {[weak self] in
            guard let view = self?.view as? FontSizeMappable else { return nil }
            
            return view.getMappedFontSize()
        }
        
        return props
    }
}

extension UILabel {
    override open func applyViewProperty(viewProperty: ELViewProperty) {
        super.applyViewProperty(viewProperty: viewProperty)
        
        LabelPropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
    
    open override func retrieveViewProperty(viewProperty: ELViewProperty) -> String? {
        return LabelPropertyResolver(view: self).retrieve(viewProperty: viewProperty)
    }
}
