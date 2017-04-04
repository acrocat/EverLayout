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

public class ELViewProperty: ELRawData {
    public var propertyParser : LayoutPropertyParser!
    
    public var name : String? {
        return self.propertyParser.propertyName(source: self.rawData)
    }
    public var value : String? {
        return self.propertyParser.propertyValue(source: self.rawData)
    }
    
    public init (rawData : Any , parser : LayoutPropertyParser) {
        super.init(rawData: rawData)
        
        self.propertyParser = parser
    }
    
    public func applyToView (viewModel : ELView) {
        guard let target = viewModel.target else { return }
        
        self.cacheExistingProperty(forView: viewModel)
        
        target.applyViewProperty(viewProperty: self)
    }
    
    private func cacheExistingProperty (forView view : ELView) {
        guard let name = self.name , let target = view.target else { return }
        
        // If there is already a cached property with this name then we move on
        if view.cachedProperties[name] == nil {
            // Attempt to retrieve the property from the view
            if let value = target.retrieveViewProperty(viewProperty: self) {
                view.cachedProperties[name] = value
            }
        }
    }
}
