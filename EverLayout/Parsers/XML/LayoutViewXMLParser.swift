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
import SwiftyXML

public class LayoutViewXMLParser : NSObject , LayoutViewParser {
    private func parseSource(source: Any?) -> XML? {
        return source as? XML
    }
    
    public func view(source: Any) -> ELView? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return ELView(rawData: source, parser: LayoutViewXMLParser())
    }
    public func viewId(source: Any?) -> String? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source.name
    }
    public func viewSuperClass(source: Any?) -> UIView.Type? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        if let className = source.attributes["targetClass"] {
            return NSClassFromString(className) as? UIView.Type
        }
        
        return nil
    }
    public func isNewElement(source: Any?) -> Bool {
        guard let source = self.parseSource(source: source) else { return false }
        
        return source.attributes["new"] == "true"
    }
    public func viewProperties(source: Any) -> [ELViewProperty?]? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source.attributes.map({ (key , value) -> ELViewProperty in
            return ELViewProperty(rawData: (key , value), parser: LayoutPropertyXMLParser())
        })
    }
    public func viewZIndex(source: Any) -> Int {
        guard let source = self.parseSource(source: source) else { return 0 }
        guard let zIndex = source.attributes["z-index"] else { return 0 }
        
        return Int(zIndex) ?? 0
    }
    public func viewConstraints(source: Any) -> [ELConstraint?]? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source["constraint"].xmlList?.map({ (xmlItem) -> ELConstraint? in
            return ELConstraint(rawData: xmlItem, parser: LayoutConstraintXMLParser())
        })
    }
    public func subviews(source: Any) -> [Any]? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source["views"].xml?.children
    }
}
