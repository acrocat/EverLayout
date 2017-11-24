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

extension UINavigationBar : TextColorMappable {
    func mapTextColor(_ color: String) {
        guard let color = UIColor.color(fromName: color) ?? UIColor(hex: color) else { return }
        
        self.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: color as Any
        ]
    }
    
    func getMappedTextColor() -> String? {
        guard let color = self.titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor else { return nil }
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
