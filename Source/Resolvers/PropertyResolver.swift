//  EverLayout
//
//  Copyright (c) 2017 Dale Webster
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

public class PropertyResolver
{   
    // ---------------------------------------------------------------------------
    // ---------------------------------------------------------------------------
    
    public weak var view : UIView?
    
    convenience init (view : UIView) {
        self.init()
        
        self.view = view
    }
    
    open var settableProperties : [String : (String) -> Void] {
        return [
            "frame": {[weak self] (source) in
                self?.view?.mapFrame(source)
            },
            "backgroundColor": {[weak self] (source) in
                self?.view?.mapBackgroundColor(source)
            },
            "cornerRadius": {[weak self] (source) in
                self?.view?.mapCornerRadius(source)
            },
            "borderWidth": {[weak self] source in
                self?.view?.mapBorderWidth(source)
            },
            "borderColor": {[weak self] source in
                self?.view?.mapBorderColor(source)
            },
            "alpha": {[weak self] source in
                self?.view?.mapAlpha(source)
            },
            "clipToBounds": {[weak self] source in
                self?.view?.mapClipToBounds(source)
            },
            "contentMode": {[weak self] source in
                self?.view?.mapContentMode(source)
            },
            "hidden": {[weak self] source in
                self?.view?.mapHidden(source)
            },
            
            // Text properties
            "text":{[weak self] source in
                if let view = self?.view as? TextMappable {
                    view.mapText(source)
                }
            },
            "textColor": {[weak self] source in
                if let view = self?.view as? TextColorMappable {
                    view.mapTextColor(source)
                }
            },
            "lineBreakMode": {[weak self] source in
                if let view = self?.view as? LineBreakModeMappable {
                    view.mapLineBreakMode(source)
                }
            },
            "textAlignment": {[weak self] source in
                if let view = self?.view as? TextAlignmentMappable {
                    view.mapTextAlignment(source)
                }
            },
            "numberOfLines": {[weak self] source in
                if let view = self?.view as? NumberOfLinesMappable {
                    view.mapNumberOfLines(source)
                }
            },
            "fontSize":{[weak self] source in
                if let view = self?.view as? FontSizeMappable {
                    view.mapFontSize(source)
                }
            },
            
            // Image properties
            "image": {[weak self] source in
                if let view = self?.view as? ImageMappable {
                    view.mapImage(source)
                }
            },
            "backgroundImage":{[weak self] source in
                if let view = self?.view as? BackgroundImageMappable {
                    view.mapBackgroundImage(source)
                }
            },
            
            // ScrollView properties
            "contentInset": {[weak self] source in
                if let view = self?.view as? ContentInsetMappable {
                    view.mapContentInset(source)
                }
            },
            "contentOffset": {[weak self] source in
                if let view = self?.view as? ContentOffsetMappable {
                    view.mapContentOffset(source)
                }
            },
            
            // TextField properties
            "placeholder": {[weak self] source in
                if let view = self?.view as? PlaceholderMappable {
                    view.mapPlaceholder(source)
                }
            },
            
            // Navigation Bar properties
            "translucent": {[weak self] source in
                if let view = self?.view as? TranslucentMappable {
                    view.mapIsTranslucent(source)
                }
            },
            "tintColor":{[weak self] source in
                if let view = self?.view as? TintColorMappable {
                    view.mapTintColor(source)
                }
            }
        ]
    }
    
    open var retrievableProperties : [String : () -> String?] {
        return [
            "frame": {[weak self] in
                return self?.view?.getMappedFrame()
            },
            "backgroundColor": {[weak self] in
                return self?.view?.getMappedBackgroundColor()
            },
            "cornerRadius": {[weak self] in
                return self?.view?.getMappedCornerRadius()
            },
            "borderWidth": {[weak self] in
                return self?.view?.getMappedBorderWidth()
            },
            "borderColor": {[weak self] in
                return self?.view?.getMappedBorderColor()
            },
            "alpha": {[weak self] in
                return self?.view?.getMappedAlpha()
            },
            "clipToBounds":{[weak self] in
                return self?.view?.getMappedClipToBounds()
            },
            "contentMode":{[weak self] in
                return self?.view?.getMappedContentMode()
            },
            "hidden": {[weak self] in 
                return self?.view?.getMappedHidden()
            },
            
            // Text properties
            "text":{[weak self] in
                guard let view = self?.view as? TextMappable else { return nil }
                
                return view.getMappedText()
            },
            "textColor": {[weak self] in
                guard let view = self?.view as? TextColorMappable else { return nil }
                
                return view.getMappedTextColor()
            },
            "lineBreakMode": {[weak self] in
                guard let view = self?.view as? LineBreakModeMappable else { return nil }
                
                return view.getMappedLineBreakMode()
            },
            "numberOfLines":{[weak self] in
                guard let view = self?.view as? NumberOfLinesMappable else { return nil }
                
                return view.getMappedNumberOfLines()
            },
            "textAlignment":{[weak self] in
                guard let view = self?.view as? TextAlignmentMappable else { return nil }
                
                return view.getMappedTextAlignment()
            },
            "fontSize":{[weak self] in
                guard let view = self?.view as? FontSizeMappable else { return nil }
                
                return view.getMappedFontSize()
            },
            
            // ScrollView properties
            "contentInset": {[weak self] in
                guard let view = self?.view as? ContentInsetMappable else { return nil }
                
                return view.getMappedContentInset()
            },
            "contentOffset": {[weak self] in
                guard let view = self?.view as? ContentOffsetMappable else { return nil }
                
                return view.getMappedContentOffset()
            },
            
            // TextField properties
            "placeholder":{[weak self] in
                guard let view = self?.view as? PlaceholderMappable else { return nil }
                
                return view.getMappedPlaceholder()
            },
            
            // Navigation Bar properties
            "translucent": {[weak self] in
                guard let view = self?.view as? TranslucentMappable else { return nil }
                
                return view.getMappedIsTranslucent()
            },
            "tintColor":{[weak self] in
                guard let view = self?.view as? TintColorMappable else { return nil }
                
                return view.getMappedTintColor()
            }
        ]
    }
    
    open func apply (viewProperty : ELViewProperty) {
        guard let name = viewProperty.name , let value = viewProperty.value else { return }
        
        if let operation = self.settableProperties[name] {
            operation(value)
        } else {
            // Unrecognised property
            // Would be nice to report this, but it doesn't cause crashes so 
            // not a priority
            
            return
        }
    }
    
    open func apply (propertyName name : String , value : String) {
        self.settableProperties[name]?(value)
    }
    
    open func retrieve (viewProperty : ELViewProperty) -> String? {
        guard let name = viewProperty.name else { return nil }
        
        return self.retrievableProperties[name]?()
    }
}

extension UIView {
    @objc open func applyViewProperty (viewProperty : ELViewProperty) {
        PropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
    
    @objc open func applyViewProperty (propertyName name : String , value : String) {
        PropertyResolver(view: self).apply(propertyName: name, value: value)
    }
    
    @objc open func retrieveViewProperty (viewProperty : ELViewProperty) -> String? {
        return PropertyResolver(view: self).retrieve(viewProperty: viewProperty)
    }
}



