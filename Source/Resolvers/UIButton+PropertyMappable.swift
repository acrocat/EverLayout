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

extension UIButton : TextMappable {
    @objc func mapText(_ text: String) {
        self.setTitle(text, for: .normal)
    }
    
    @objc func getMappedText() -> String? {
        return self.title(for: .normal) ?? ""
    }
}
extension UIButton : FontSizeMappable {
    @objc func mapFontSize(_ fontSize: String) {
        self.titleLabel?.font = self.titleLabel?.font.withSize(fontSize.toCGFloat() ?? 16)
    }
    
    @objc func getMappedFontSize() -> String? {
        return self.titleLabel?.font.pointSize.description
    }
}
extension UIButton : TextColorMappable {
    @objc func mapTextColor(_ color: String) {
        self.setTitleColor(UIColor.color(fromName: color) ?? UIColor(hex: color), for: .normal)
    }
    
    @objc func getMappedTextColor() -> String? {
        guard let color = self.titleColor(for: .normal) else { return nil }
        
        return UIColor.name(ofColor: color)
    }
}
extension UIButton : BackgroundImageMappable {
    @objc func mapBackgroundImage(_ image: String) {
        var imageInstance = UIImage(named: image)
        
        if imageInstance == nil {
            imageInstance = UIImage(address: image)
        }
        
        self.setBackgroundImage(imageInstance, for: .normal)
    }
}
extension UIButton : ImageMappable {
    @objc func mapImage(_ image: String) {
        var imageInstance = UIImage(named: image)
        
        if imageInstance == nil {
            imageInstance = UIImage(address: image)
        }
        
        self.setImage(imageInstance, for: .normal)
    }
}
