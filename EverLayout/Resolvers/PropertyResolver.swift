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
    // ---------------------------------------------------------------------------
    
    public weak var view : UIView?
    
    convenience init (view : UIView) {
        self.init()
        
        self.view = view
    }
    
    open var settableProperties : [String : (String) -> Void] {
        return [
            "frame": {[weak self] (source) in
                self?.view?.mapFrame(source)
            },
            "backgroundColor": {[weak self] (source) in
                self?.view?.mapBackgroundColor(source)
            },
            "cornerRadius": {[weak self] (source) in
                self?.view?.mapCornerRadius(source)
            },
            "borderWidth": {[weak self] source in
                self?.view?.mapBorderWidth(source)
            },
            "borderColor": {[weak self] source in
                self?.view?.mapBorderColor(source)
            },
            "alpha": {[weak self] source in
                self?.view?.mapAlpha(source)
            },
            "clipToBounds": {[weak self] source in
                self?.view?.mapClipToBounds(source)
            },
            "contentMode": {[weak self] source in
                self?.view?.mapContentMode(source)
            },
            "hidden": {[weak self] source in
                self?.view?.mapHidden(source)
            }
        ]
    }
    
    open var retrievableProperties : [String : () -> String?] {
        return [
            "frame": {[weak self] in
                return self?.view?.getMappedFrame()
            },
            "backgroundColor": {[weak self] in
                return self?.view?.getMappedBackgroundColor()
            },
            "cornerRadius": {[weak self] in
                return self?.view?.getMappedCornerRadius()
            },
            "borderWidth": {[weak self] in
                return self?.view?.getMappedBorderWidth()
            },
            "borderColor": {[weak self] in
                return self?.view?.getMappedBorderColor()
            },
            "alpha": {[weak self] in
                return self?.view?.getMappedAlpha()
            },
            "clipToBounds":{[weak self] in
                return self?.view?.getMappedClipToBounds()
            },
            "contentMode":{[weak self] in
                return self?.view?.getMappedContentMode()
            },
            "hidden": {[weak self] in 
                return self?.view?.getMappedHidden()
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
}

extension UIView {
    open func applyViewProperty (viewProperty : ELViewProperty) {
        PropertyResolver(view: self).apply(viewProperty: viewProperty)
    }
    
    open func retrieveViewProperty (viewProperty : ELViewProperty) -> String? {
        return PropertyResolver(view: self).retrieve(viewProperty: viewProperty)
    }
}



