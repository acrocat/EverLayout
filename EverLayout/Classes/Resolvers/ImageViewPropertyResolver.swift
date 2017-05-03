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

public class ImageViewPropertyResolver: PropertyResolver
{
    override public var settableProperties: [String : (String) -> Void] {
        var props = super.settableProperties
        
        props["image"] = {[weak self] (source) in
            if let view = self?.view as? ImageMappable {
                view.mapImage(source)
            }
        }
        
        return props
    }
}

extension UIImageView {
    override open func applyViewProperty(viewProperty: ELViewProperty) {
        super.applyViewProperty(viewProperty: viewProperty)
        
        ImageViewPropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
    
    open override func retrieveViewProperty(viewProperty: ELViewProperty) -> String? {
        return TextFieldPropertyResolver(view: self).retrieve(viewProperty: viewProperty)
    }
}
