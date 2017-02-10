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
    
    open var exposedProperties : [String : (String) -> Void] {
        return [
            "backgroundColor": {(source) in
                self.view?.backgroundColor = PropertyResolver.color(value: source)
            },
            "cornerRadius": {(source) in
                self.view?.layer.cornerRadius = PropertyResolver.number(value: source) ?? 0
            },
            "borderWidth": {source in
                self.view?.layer.borderWidth = PropertyResolver.number(value: source) ?? 0
            },
            "borderColor": {source in
                self.view?.layer.borderColor = PropertyResolver.color(value: source)?.cgColor
            },
            "alpha": {source in
                self.view?.alpha = PropertyResolver.number(value: source) ?? 1
            },
            "clipToBounds": {source in
                self.view?.clipsToBounds = PropertyResolver.bool(value: source)
            },
            "contentMode": {source in
                self.view?.contentMode = PropertyResolver.contentMode(source: source) ?? .scaleToFill
            }
        ]
    }
    
    open func apply (viewProperty : ELViewProperty)
    {
        guard let name = viewProperty.name , let value = viewProperty.value else { return }
        
        if let operation = self.exposedProperties[name]
        {
            operation(value)
        }
        else
        {
            // Unrecognised property
        }
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
    open func applyViewProperty (viewProperty : ELViewProperty)
    {   
        PropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
}



