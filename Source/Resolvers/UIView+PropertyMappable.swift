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

/*
    Behaviour of UIView when properties are mapped to from it
*/

extension UIView : FrameMappable {
    @objc func mapFrame(_ frame: String) {
        self.frame = CGRectFromString(frame)
    }
    
    @objc func getMappedFrame() -> String? {
        return NSStringFromCGRect(self.frame) as String
    }
}

extension UIView : BackgroundColorMappable {
    @objc func mapBackgroundColor(_ color: String) {
        self.backgroundColor = UIColor.color(fromName: color) ?? UIColor(hex: color) ?? .clear
    }
    
    @objc func getMappedBackgroundColor() -> String? {
        return UIColor.name(ofColor: self.backgroundColor ?? .clear)
    }
}
extension UIView : HiddenMappable {
    @objc func mapHidden(_ hidden: String) {
        self.isHidden = (hidden.lowercased() == "true")
    }
    
    @objc func getMappedHidden() -> String? {
        return self.isHidden ? "true" : "false"
    }
}
extension UIView : CornerRadiusMappable {
    @objc func mapCornerRadius(_ cornerRadius: String) {
        self.layer.cornerRadius = cornerRadius.toCGFloat() ?? 0
    }
    
    @objc func getMappedCornerRadius() -> String? {
        return self.layer.cornerRadius.description
    }
}
extension UIView : BorderWidthMappable {
    @objc func mapBorderWidth(_ borderWidth: String) {
        self.layer.borderWidth = borderWidth.toCGFloat() ?? 0
    }
    
    @objc func getMappedBorderWidth() -> String? {
        return self.layer.borderWidth.description
    }
}
extension UIView : BorderColorMappable {
    @objc func mapBorderColor(_ borderColor: String) {
        self.layer.borderColor = UIColor.color(fromName: borderColor)?.cgColor ?? UIColor(hex: borderColor)?.cgColor
    }
    
    @objc func getMappedBorderColor() -> String? {
        guard let borderColor = self.layer.borderColor else { return nil }
        
        return UIColor.name(ofColor: UIColor(cgColor: borderColor))
    }
}
extension UIView : AlphaMappable {
    @objc func mapAlpha(_ alpha: String) {
        self.alpha = alpha.toCGFloat() ?? 1
    }
    
    @objc func getMappedAlpha() -> String? {
        return self.alpha.description
    }
}
extension UIView : ClipBoundsMappable {
    @objc func mapClipToBounds(_ clipToBounds: String) {
        self.clipsToBounds = (clipToBounds.lowercased() == "true")
    }
    
    @objc func getMappedClipToBounds() -> String? {
        return  self.clipsToBounds ? "true" : "false"
    }
}
extension UIView : ContentModeMappable {
    internal var contentModes : [String : UIViewContentMode] {
        return [
            "scaleToFill" : .scaleToFill,
            "scaleAspectFit" : .scaleAspectFit,
            "scaleAspectFill" : .scaleAspectFill,
            "redraw" : .redraw,
            "center" : .center,
            "top" : .top,
            "bottom" : .bottom,
            "left" : .left,
            "right" : .right,
            "topLeft" : .topLeft,
            "topRight" : .topRight,
            "bottomLeft" : .bottomLeft,
            "bottomRight" : .bottomRight
        ]
    }
    
    @objc func mapContentMode(_ contentMode: String) {
        if let contentMode = self.contentModes[contentMode] {
            self.contentMode = contentMode
        }
    }
    
    @objc func getMappedContentMode() -> String? {
        return self.contentModes.filter { (key , value) -> Bool in
            return value == self.contentMode
            }.first?.key
    }
}
