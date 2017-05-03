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

// MARK: - Mappable Protocols

protocol FrameMappable {
    func mapFrame (_ frame : String)
    
    func getMappedFrame () -> String?
}

protocol BackgroundColorMappable {
    func mapBackgroundColor (_ color : String)
    
    func getMappedBackgroundColor () -> String?
}

protocol HiddenMappable {
    func mapHidden (_ hidden : String)
    
    func getMappedHidden () -> String?
}

protocol CornerRadiusMappable {
    func mapCornerRadius (_ cornerRadius : String)
    
    func getMappedCornerRadius () -> String?
}

protocol BorderWidthMappable {
    func mapBorderWidth (_ borderWidth : String)
    
    func getMappedBorderWidth () -> String?
}

protocol BorderColorMappable {
    func mapBorderColor (_ borderColor : String)
    
    func getMappedBorderColor () -> String?
}

protocol AlphaMappable {
    func mapAlpha (_ alpha : String)
    
    func getMappedAlpha () -> String?
}

protocol ClipBoundsMappable {
    func mapClipToBounds (_ clipToBounds : String)
    
    func getMappedClipToBounds () -> String?
}

protocol ContentModeMappable {
    func mapContentMode (_ contentMode : String)
    
    func getMappedContentMode () -> String?
}

protocol TextMappable {
    func mapText (_ text : String)
    
    func getMappedText () -> String?
}

protocol TextColorMappable {
    func mapTextColor (_ color : String)
    
    func getMappedTextColor () -> String?
}

protocol LineBreakModeMappable {
    func mapLineBreakMode (_ lineBreakMode : String)
    
    func getMappedLineBreakMode () -> String?
}

protocol TextAlignmentMappable {
    func mapTextAlignment (_ textAlignment : String)
    
    func getMappedTextAlignment () -> String?
}

protocol NumberOfLinesMappable {
    func mapNumberOfLines (_ numberOfLines : String)
    
    func getMappedNumberOfLines () -> String?
}

protocol FontSizeMappable {
    func mapFontSize (_ fontSize : String)
    
    func getMappedFontSize () -> String?
}

protocol BackgroundImageMappable {
    func mapBackgroundImage (_ image : String)
}

protocol ImageMappable {
    func mapImage (_ image : String)
}

protocol ContentInsetMappable {
    func mapContentInset (_ contentInset : String)
    
    func getMappedContentInset () -> String?
}

protocol ContentOffsetMappable {
    func mapContentOffset (_ contentOffset : String)
    
    func getMappedContentOffset () -> String?
}

protocol PlaceholderMappable {
    func mapPlaceholder (_ placeholder : String)
    
    func getMappedPlaceholder () -> String?
}

protocol TranslucentMappable {
    func mapIsTranslucent (_ translucent : String)
    
    func getMappedIsTranslucent () -> String?
}

protocol TintColorMappable {
    func mapTintColor (_ tintColor : String)
    
    func getMappedTintColor () -> String?
}

// MARK: - UIView Implementations
extension UIView : FrameMappable {
    func mapFrame(_ frame: String) {
        self.frame = CGRectFromString(frame)
    }
    
    func getMappedFrame() -> String? {
        return NSStringFromCGRect(self.frame) as String
    }
}

extension UIView : BackgroundColorMappable {
    func mapBackgroundColor(_ color: String) {
        self.backgroundColor = UIColor.color(fromName: color) ?? UIColor(hex: color) ?? .clear
    }
    
    func getMappedBackgroundColor() -> String? {
        return UIColor.name(ofColor: self.backgroundColor ?? .clear)
    }
}
extension UIView : HiddenMappable {
    func mapHidden(_ hidden: String) {
        self.isHidden = (hidden.lowercased() == "true")
    }
    
    func getMappedHidden() -> String? {
        return self.isHidden ? "true" : "false"
    }
}
extension UIView : CornerRadiusMappable {
    func mapCornerRadius(_ cornerRadius: String) {
        self.layer.cornerRadius = cornerRadius.toCGFloat() ?? 0
    }
    
    func getMappedCornerRadius() -> String? {
        return self.layer.cornerRadius.description
    }
}
extension UIView : BorderWidthMappable {
    func mapBorderWidth(_ borderWidth: String) {
        self.layer.cornerRadius = borderWidth.toCGFloat() ?? 0
    }
    
    func getMappedBorderWidth() -> String? {
        return self.layer.cornerRadius.description
    }
}
extension UIView : BorderColorMappable {
    func mapBorderColor(_ borderColor: String) {
        self.layer.borderColor = UIColor.color(fromName: borderColor)?.cgColor ?? UIColor(hex: borderColor)?.cgColor
    }
    
    func getMappedBorderColor() -> String? {
        guard let borderColor = self.layer.borderColor else { return nil }
        
        return UIColor.name(ofColor: UIColor(cgColor: borderColor))
    }
}
extension UIView : AlphaMappable {
    func mapAlpha(_ alpha: String) {
        self.alpha = alpha.toCGFloat() ?? 1
    }
    
    func getMappedAlpha() -> String? {
        return self.alpha.description
    }
}
extension UIView : ClipBoundsMappable {
    func mapClipToBounds(_ clipToBounds: String) {
        self.clipsToBounds = (clipToBounds.lowercased() == "true")
    }
    
    func getMappedClipToBounds() -> String? {
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
    
    func mapContentMode(_ contentMode: String) {
        if let contentMode = self.contentModes[contentMode] {
            self.contentMode = contentMode
        }
    }
    
    func getMappedContentMode() -> String? {
        return self.contentModes.filter { (key , value) -> Bool in
            return value == self.contentMode
        }.first?.key
    }
}

// MARK: - UILabel Implementations
extension UILabel : TextMappable {
    func mapText(_ text: String) {
        self.text = text
    }
    
    func getMappedText() -> String? {
        return self.text ?? ""
    }
}
extension UILabel : TextColorMappable {
    func mapTextColor(_ color: String) {
        self.textColor = UIColor.color(fromName: color) ?? UIColor(hex: color)
    }
    
    func getMappedTextColor() -> String? {
        return UIColor.name(ofColor: self.textColor)
    }
}
extension UILabel : LineBreakModeMappable {
    internal var lineBreakModes : [String : NSLineBreakMode] {
        return [
            "byWordWrapping": .byWordWrapping,
            "byCharWrapping": .byCharWrapping,
            "byClipping": .byClipping,
            "byTruncatingHead": .byTruncatingHead,
            "byTruncatingTail": .byTruncatingTail,
            "byTruncatingMiddle": .byTruncatingMiddle
        ]
    }
    
    func mapLineBreakMode(_ lineBreakMode: String) {
        if let breakMode = self.lineBreakModes[lineBreakMode] {
            self.lineBreakMode = breakMode
        }
    }
    
    func getMappedLineBreakMode() -> String? {
        return self.lineBreakModes.filter { (key , value) -> Bool in
            return value == self.lineBreakMode
            }.first?.key
    }
}
extension UILabel : TextAlignmentMappable {
    internal var textAlignments : [String : NSTextAlignment] {
        return [
            "left": .left,
            "center": .center,
            "right": .right,
            "justified": .justified,
            "natural": .natural
        ]
    }
    
    func mapTextAlignment(_ textAlignment: String) {
        if let alignment = self.textAlignments[textAlignment] {
            self.textAlignment = alignment
        }
    }
    
    func getMappedTextAlignment() -> String? {
        return self.textAlignments.filter { (key , value) -> Bool in
            return value == self.textAlignment
            }.first?.key
    }
}
extension UILabel : NumberOfLinesMappable {
    func mapNumberOfLines(_ numberOfLines: String) {
        if let linesInt = Int(numberOfLines) {
            self.numberOfLines = linesInt
        }
    }
    
    func getMappedNumberOfLines() -> String? {
        return String(self.numberOfLines)
    }
}
extension UILabel : FontSizeMappable {
    func mapFontSize(_ fontSize: String) {
        if let float = fontSize.toCGFloat() {
            self.font = self.font.withSize(float)
        }
    }
    
    func getMappedFontSize() -> String? {
        return String(describing: self.font.pointSize)
    }
}

// MARK: - UIButton Implementation
extension UIButton : TextMappable {
    func mapText(_ text: String) {
        self.setTitle(text, for: .normal)
    }
    
    func getMappedText() -> String? {
        return self.title(for: .normal) ?? ""
    }
}
extension UIButton : TextColorMappable {
    func mapTextColor(_ color: String) {
        self.setTitleColor(UIColor.color(fromName: color) ?? UIColor(hex: color), for: .normal)
    }
    
    func getMappedTextColor() -> String? {
        guard let color = self.titleColor(for: .normal) else { return nil }
        
        return UIColor.name(ofColor: color)
    }
}
extension UIButton : BackgroundImageMappable {
    func mapBackgroundImage(_ image: String) {
        var imageInstance = UIImage(named: image)
        
        if imageInstance == nil {
            imageInstance = UIImage(address: image)
        }
        
        self.setBackgroundImage(imageInstance, for: .normal)
    }
}
extension UIButton : ImageMappable {
    func mapImage(_ image: String) {
        var imageInstance = UIImage(named: image)
        
        if imageInstance == nil {
            imageInstance = UIImage(address: image)
        }
        
        self.setImage(imageInstance, for: .normal)
    }
}

// MARK: - UIImageView Implementation
extension UIImageView : ImageMappable {
    func mapImage(_ image: String) {
        var imageInstance = UIImage(named: image)
        
        if imageInstance == nil {
            imageInstance = UIImage(address: image)
        }
        
        self.image = imageInstance
    }
}

// MARK: - UIScrollView Implementations
extension UIScrollView : ContentInsetMappable {
    func mapContentInset(_ contentInset: String) {
        self.contentInset = UIEdgeInsetsFromString(contentInset)
    }
    
    func getMappedContentInset() -> String? {
        return NSStringFromUIEdgeInsets(self.contentInset) as String
    }
}
extension UIScrollView : ContentOffsetMappable {
    func mapContentOffset(_ contentOffset: String) {
        self.contentOffset = CGPointFromString(contentOffset)
    }
    
    func getMappedContentOffset() -> String? {
        return NSStringFromCGPoint(self.contentOffset) as String
    }
}

// MARK: - UITextField Implementations
extension UITextField : PlaceholderMappable {
    func mapPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
    }
    
    func getMappedPlaceholder() -> String? {
        return self.placeholder ?? ""
    }
}

// MARK: - UINavigationController Implementations
extension UINavigationBar : TextColorMappable {
    func mapTextColor(_ color: String) {
        guard let color = UIColor.color(fromName: color) ?? UIColor(hex: color) else { return }
        
        self.titleTextAttributes = [
            NSForegroundColorAttributeName : color as Any
        ]
    }
    
    func getMappedTextColor() -> String? {
        guard let color = self.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor else { return nil }
        
        return UIColor.name(ofColor: color)
    }
}

extension UINavigationBar : TranslucentMappable {
    func mapIsTranslucent(_ translucent: String) {
        self.isTranslucent = translucent.lowercased() == "true"
    }
    
    func getMappedIsTranslucent() -> String? {
        return self.isTranslucent ? "true" : "false"
    }
}

extension UINavigationBar {
    override func mapBackgroundColor(_ color: String) {
        self.barTintColor = UIColor.color(fromName: color) ?? UIColor(hex: color)
    }
    
    override func getMappedBackgroundColor() -> String? {
        guard let color = self.barTintColor else { return nil }
        
        return UIColor.name(ofColor: color)
    }
}

extension UINavigationBar : TintColorMappable {
    func mapTintColor(_ tintColor: String) {
        self.tintColor = UIColor.color(fromName: tintColor) ?? UIColor(hex: tintColor)
    }
    
    func getMappedTintColor() -> String? {
        return UIColor.name(ofColor: self.tintColor)
    }
}


