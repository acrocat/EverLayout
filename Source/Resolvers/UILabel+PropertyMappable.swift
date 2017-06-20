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
 Behaviour of UILabel when properties are mapped to and from it
*/

extension UILabel : TextMappable {
    @objc func mapText(_ text: String) {
        self.text = text
    }
    
    @objc func getMappedText() -> String? {
        return self.text ?? ""
    }
}
extension UILabel : TextColorMappable {
    @objc func mapTextColor(_ color: String) {
        self.textColor = UIColor.color(fromName: color) ?? UIColor(hex: color)
    }
    
    @objc func getMappedTextColor() -> String? {
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
    
    @objc func mapLineBreakMode(_ lineBreakMode: String) {
        if let breakMode = self.lineBreakModes[lineBreakMode] {
            self.lineBreakMode = breakMode
        }
    }
    
    @objc func getMappedLineBreakMode() -> String? {
        return self.lineBreakModes.filter { (arg) -> Bool in
            
            let (key, value) = arg
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
    
    @objc func mapTextAlignment(_ textAlignment: String) {
        if let alignment = self.textAlignments[textAlignment] {
            self.textAlignment = alignment
        }
    }
    
    @objc func getMappedTextAlignment() -> String? {
        return self.textAlignments.filter { (arg) -> Bool in
            
            let (key, value) = arg
            return value == self.textAlignment
            }.first?.key
    }
}
extension UILabel : NumberOfLinesMappable {
    @objc func mapNumberOfLines(_ numberOfLines: String) {
        if let linesInt = Int(numberOfLines) {
            self.numberOfLines = linesInt
        }
    }
    
    @objc func getMappedNumberOfLines() -> String? {
        return String(self.numberOfLines)
    }
}
extension UILabel : FontSizeMappable {
    @objc func mapFontSize(_ fontSize: String) {
        if let float = fontSize.toCGFloat() {
            self.font = self.font.withSize(float)
        }
    }
    
    @objc func getMappedFontSize() -> String? {
        return String(describing: self.font.pointSize)
    }
}
