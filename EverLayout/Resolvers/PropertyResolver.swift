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
    // MARK: - Enum Mapping
    // ---------------------------------------------------------------------------
    
    private static let CONTENT_MODE_KEYS : [String] = [
        "scaleToFit",
        "scaleAspectFit",
        "scaleAspectFill",
        "redraw",
        "center",
        "top",
        "bottom",
        "left",
        "right",
        "topLeft",
        "topRight",
        "bottomLeft",
        "bottomRight"
    ]
    
    // ---------------------------------------------------------------------------
    // ---------------------------------------------------------------------------
    
    public weak var view : UIView?
    
    convenience init (view : UIView)
    {
        self.init()
        
        self.view = view
    }
    
    open var settableProperties : [String : (String) -> Void] {
        return [
            "backgroundColor": {(source) in
                self.view?.mapBackgroundColor(source)
            },
            "cornerRadius": {(source) in
                self.view?.mapCornerRadius(source)
            },
            "borderWidth": {source in
                self.view?.mapBorderWidth(source)
            },
            "borderColor": {source in
                self.view?.mapBorderColor(source)
            },
            "alpha": {source in
                self.view?.mapAlpha(source)
            },
            "clipToBounds": {source in
                self.view?.mapClipToBounds(source)
            },
            "contentMode": {source in
                self.view?.mapContentMode(source)
            }
        ]
    }
    
    open var retrievableProperties : [String : () -> String?] {
        return [
            "backgroundColor": {
                return self.view?.getMappedBackgroundColor()
            },
            "cornerRadius": {
                return self.view?.getMappedCornerRadius()
            },
            "borderWidth": {
                return self.view?.getMappedBorderWidth()
            },
            "borderColor": {
                return self.view?.getMappedBorderColor()
            },
            "alpha": {
                return self.view?.getMappedAlpha()
            },
            "clipToBounds":{
                return self.view?.getMappedClipToBounds()
            },
            "contentMode":{
                return self.view?.getMappedContentMode()
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
    
    open func retrieve (viewProperty : ELViewProperty) -> String? {
        guard let name = viewProperty.name else { return nil }
        
        return self.retrievableProperties[name]?()
    }
    
    public static func number (value : String) -> CGFloat?
    {
        return value.toCGFloat()
    }
    
    public static func string (value : String) -> String?
    {
        return value
    }
    
    public static func color (value : String) -> UIColor?
    {
        return UIColor.color(fromName: value) ?? UIColor(hex: value)
    }
    
    public static func bool (value : String) -> Bool
    {
        return value == "true"
    }
    
    static func contentMode (source : String) -> UIViewContentMode?
    {
        guard let index = self.CONTENT_MODE_KEYS.index(of: source) else { return nil }
        
        return UIViewContentMode(rawValue: index)
    }
    
    /// Uses CGPointFromString to parse a CGPoint from the property value
    ///
    /// - Parameter source: Property value as String
    /// - Returns: CGPoint
    static func point (source: String) -> CGPoint?
    {
        return CGPointFromString(source)
    }
    
    /// Uses UIEdgeInsetFromString to parse UIEdgeInset from property value
    ///
    /// - Parameter source: Property value as String
    /// - Returns: UIEdgeInset
    static func edgeInset (source : String) -> UIEdgeInsets?
    {
        return UIEdgeInsetsFromString(source)
    }
    
    /// Uses CGSizeFromString to parse CGSize from property value
    ///
    /// - Parameter source: Property value as String
    /// - Returns: CGSize
    static func size (source : String) -> CGSize?
    {
        return CGSizeFromString(source)
    }
}

extension UIView
{
    open func applyViewProperty (viewProperty : ELViewProperty) {
        PropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
    
    open func retrieveViewProperty (viewProperty : ELViewProperty) -> String? {
        return PropertyResolver(view: self).retrieve(viewProperty: viewProperty)
    }
}



