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
