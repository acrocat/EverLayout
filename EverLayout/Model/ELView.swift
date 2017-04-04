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

public class ELView: ELRawData
{
    public var viewParser : LayoutViewParser!
    
    public var id : String? {
        return self.viewParser.viewId(source: self.rawData)
    }
    public var templateClass : UIView.Type? {
        return self.viewParser.viewSuperClass(source: self.rawData)
    }
    public var constraints : [ELConstraint?]? {
        return self.viewParser.viewConstraints(source: self.rawData)
    }
    public var properties : [ELViewProperty?]? {
        return self.viewParser.viewProperties(source: self.rawData)
    }
    public var zIndex : Int {
        return self.viewParser.viewZIndex(source: self.rawData)
    }
    public var isNewElement : Bool {
        return self.viewParser.isNewElement(source: self.rawData)
    }
    public var subviews : [ELView?]? {
        return self.viewParser.subviews(source: self.rawData)
    }
    public var templateLayouts : [String]? {
        return self.viewParser.templateLayout(source: self.rawData)
    }
    
    // Actual constraints that are created when this view is built on a view
    public var appliedConstraints : [NSLayoutConstraint] = []
    
    // We cache view properties when EverLayout writes new ones, so that they can be reversed if the layout is unloaded
    public var cachedProperties : [String : String] = [:]
    
    // The view this model renders to
    public var target : UIView?
    
    // The model that this view is a child of in the index
    public var parentModel : ELView?
    
    // The view is at the root of a layout file
    public var isRoot : Bool = false
    
    // When a view is removed during a layout update, we mark it inactive so it won't show but its state will be preserved
    public var isActive : Bool = true
    
    public init (rawData : Any , parser : LayoutViewParser) {
        super.init(rawData: rawData)
        
        self.viewParser = parser
    }
    
    public func update (newData : Any) {
        // Set new data
        self.rawData = newData
        
        // Mark as active again
        self.isActive = true
    }
    
    public func remove () {
        if !self.isRoot {
            self.target?.removeFromSuperview()
        } else {
            self.target?.removeConstraints(self.appliedConstraints)
        }
        
        // Empty the applied constraints
        self.appliedConstraints = []
        
        // Mark as inactive
        self.isActive = false
        
        // Reset the view properties to those that were cached
        self.cachedProperties.forEach { (propName , propValue) in
            let prop = ELViewProperty(rawData: (propName , propValue), parser: LayoutPropertyJSONParser())
            
            self.target?.applyViewProperty(viewProperty: prop)
        }
    }
}
