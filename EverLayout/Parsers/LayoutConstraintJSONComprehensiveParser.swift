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

class LayoutConstraintJSONComprehensiveParser: LayoutConstraintJSONParser , LayoutConstraintParser {
    private func parseSource (source : Any) -> (lhs: String , rhs: Dictionary<String , JSON>)? {
        guard let source = source as? (String , Dictionary<String , JSON>) else {
            ELReporter.default.error(message: "Constraint source in unrecognized format.")
            return nil
        }
        
        return (lhs: source.0 , rhs: source.1)
    }
    
    func leftSideAttributes(source: Any) -> [NSLayoutAttribute?]? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        let comps = source.lhs.components(separatedBy: String(LayoutConstraintJSONShorthandParser.ATTRIBUTE_SEPARATOR))
        var attrs = [NSLayoutAttribute]()
        
        for comp in comps
        {
            if let attr = LayoutConstraintJSONShorthandParser.ATTRIBUTE_KEYS[comp]
            {
                attrs.append(attr)
            }
            else if let attr = LayoutConstraintJSONShorthandParser.COMPOUND_ATTRIBUTE_KEYS[comp]
            {
                attrs.append(contentsOf: attr)
            }
        }
        
        return attrs
    }
    
    func relation(source: Any) -> NSLayoutRelation? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        if let relation = source.rhs["relation"]?.string {
            return LayoutConstraintJSONParser.COMP_RELATION_KEYS[relation] ?? .equal
        }
        
        return .equal
    }
    
    func constant(source: Any) -> ELConstraintConstant? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        if let constant = source.rhs["constant"]?.float {
            return ELConstraintConstant(value: constant, sign: .positive)
        } else if let constant = source.rhs["constant"]?.string?.toCGFloat() {
            return ELConstraintConstant(value: constant, sign: .positive)
        }
        
        return nil
    }
    
    func multiplier(source: Any) -> ELConstraintMultiplier? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        if let multiplier = source.rhs["multiplier"]?.float {
            return ELConstraintMultiplier(value: multiplier, sign: .multiply)
        } else if let multiplier = source.rhs["multiplier"]?.string?.toCGFloat() {
            return ELConstraintMultiplier(value: multiplier, sign: .multiply)
        }
        
        return nil
    }
    
    func priority(source: Any) -> CGFloat? {
        guard let source = self.parseSource(source: source) else { return nil }

        return source.rhs["priority"]?.float ?? source.rhs["priority"]?.string?.toCGFloat()
    }
    
    func rightSideAttribute(source: Any) -> NSLayoutAttribute? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        if let attr = source.rhs["attribute"]?.string {
            return LayoutConstraintJSONShorthandParser.ATTRIBUTE_KEYS[attr]
        }
        
        return nil
    }
    
    func comparableViewReference(source: Any) -> String? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source.rhs["to"]?.string
    }
    
    func verticalSizeClass(source: Any) -> UIUserInterfaceSizeClass? {
        guard let source = self.parseSource(source: source) else { return nil }
        guard let sizeClassKey = source.rhs["verticalSizeClass"]?.string else { return nil }
        
        return LayoutConstraintJSONParser.COMP_SIZE_CLASS_KEYS[sizeClassKey]
    }
    
    func horizontalSizeClass(source: Any) -> UIUserInterfaceSizeClass? {
        guard let source =  self.parseSource(source: source) else { return nil }
        guard let sizeClassKey = source.rhs["horizontalSizeClass"]?.string else { return nil }
        
        return LayoutConstraintJSONParser.COMP_SIZE_CLASS_KEYS[sizeClassKey]
    }
    
    func identifier(source: Any) -> String? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source.rhs["identifier"]?.string
    }
}
