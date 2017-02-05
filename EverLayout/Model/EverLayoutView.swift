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

public class EverLayoutView: EverLayoutRawData
{
    public var viewParser : EverLayoutViewParser!
    
    public var id : String? {
        return self.viewParser.viewId(source: self.rawData)
    }
    public var templateClass : UIView.Type? {
        return self.viewParser.viewSuperClass(source: self.rawData)
    }
    public var constraints : [EverLayoutConstraint?]? {
        return self.viewParser.viewConstraints(source: self.rawData)
    }
    public var properties : [EverLayoutViewProperty?]? {
        return self.viewParser.viewProperties(source: self.rawData)
    }
    public var isNewElement : Bool {
        return self.viewParser.isNewElement(source: self.rawData)
    }
    public var subviews : [Any]? {
        return self.viewParser.subviews(source: self.rawData)
    }
    
    // The view this model renders to
    public var target : UIView?
    
    // The model that this view is a child of in the index
    public var parentModel : EverLayoutView?
    
    // The view is at the root of a layout file
    public var isRoot : Bool = false
    
    convenience init (rawData : Any , parser : EverLayoutViewParser)
    {
        self.init(withRawData: rawData)
        
        self.viewParser = parser
    }
}
