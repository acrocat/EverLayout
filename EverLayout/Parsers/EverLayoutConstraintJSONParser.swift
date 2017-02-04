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

class EverLayoutConstraintJSONParser: NSObject , EverLayoutConstraintParser
{
    /*
        Example constraints
        "top:left:right:bottom":"s:+12:*1.2"
    */
    
    public static let ATTRIBUTE_KEYS : [String : NSLayoutAttribute] = [
        "left": .left,
        "right": .right,
        "top": .top,
        "bottom": .bottom,
        "leading" : .leading,
        "trailing" : .trailing,
        "width": .width,
        "height": .height,
        "centerX": .centerX,
        "centerY": .centerY,
        "lastBaseline": .lastBaseline,
        "firstBaseline": .firstBaseline,
        "leftMargin": .leftMargin,
        "rightMargin": .rightMargin,
        "topMargin": .topMargin,
        "bottomMargin": .bottomMargin,
        "leadingMargin": .leadingMargin,
        "trailingMargin": .trailingMargin,
        "centerXWithinMargins": .centerXWithinMargins,
        "centerYWithinMargins": .centerYWithinMargins
    ]
    
    public static let COMPOUND_ATTRIBUTE_KEYS : [String : [NSLayoutAttribute]] = [
        "edges": [.top, .left, .bottom, .right],
        "center": [.centerX, .centerY]
    ]
    
    public static let RELATION_KEYS : [String : NSLayoutRelation] = [
        "<=" : NSLayoutRelation.lessThanOrEqual,
        "=": NSLayoutRelation.equal,
        ">=": NSLayoutRelation.greaterThanOrEqual
    ]
    
    public static let ATTRIBUTE_SEPARATOR : Character = ":"
    public static let VIEW_ATTRIBUTE_SEPARATOR : Character = "."
    
    public static let MOD_TARGET_VIEW : Character = "@"
    public static let MOD_RELATION : Character = "%"
    public static let MOD_POSITIVE_CONST : Character = "+"
    public static let MOD_NEGATIVE_CONST : Character = "-"
    public static let MOD_INSET_CONST : Character = "<"
    public static let MOD_OFFSET_CONST : Character = ">"
    
    public static let MOD_MULTIPLIER : Character = "*"
    public static let MOD_DIVIDER : Character = "/"
    
    public static let MOD_PRIORITY : Character = "$"
    
    private static let INDEPENDANT_ATTRIBUTE_KEYS : [NSLayoutAttribute] = [
        .width,
        .height
    ]
    
    /// Convert the source data into (lhs: String , rhs: String) format
    ///
    /// - Parameter source: Raw source data
    /// - Returns: (lhs: String , rhs: String)
    private func parseSource (source : Any) -> (lhs : String , rhs : String)?
    {
        guard let source = source as? (String , String) else {
            EverLayoutReporter.default.error(message: "Constraint source in unrecognized format.")
            return nil
        }
        
        return (lhs: source.0 , rhs: source.1)
    }
    
    /// Parse an array of arguments [String] from a String of raw arguments
    ///
    /// - Parameter string: Raw argument data
    /// - Returns: [String] array of arguments
    private func parseArguments (fromString string : String) -> [String]?
    {
        return string.components(separatedBy: String(EverLayoutConstraintJSONParser.ATTRIBUTE_SEPARATOR))
    }

    /// Finds the value for an argument, specified by its modifier character, if it exists
    ///
    /// - Parameters:
    ///   - mod: The modifier character to check for
    ///   - argumentString: The raw data string containing all available arguments
    /// - Returns: String value of the argument if it exists
    private func valueForArgument (withModCharacter mod : Character , argumentString : String) -> String?
    {
        guard let arguments = self.parseArguments(fromString: argumentString) else { return nil }
        
        for arg in arguments
        {
            if arg.characters.first == mod
            {
                var value = arg
                value.characters.removeFirst()
                
                return value
            }
        }
        
        return nil
    }
    
    /// Finds the first valid value for an argument when several potential mod characters are suggested
    ///
    /// - Parameters:
    ///   - mod: Array of mod characters
    ///   - argumentString: Raw data string containing all available arguments
    /// - Returns: String value of the argument if it exists and the mod character it was found with
    private func valueForArgument (withModCharacters mod : [Character] , argumentString : String) -> (character: Character , value : String)?
    {
        for char in mod
        {
            if let value = self.valueForArgument(withModCharacter: char, argumentString: argumentString)
            {
                return (
                    character: char,
                    value: value
                )
            }
        }
        
        return nil
    }
    
    /// ID of the target view - this is a raw ID so will include the superclass data if it exists
    ///
    /// - Parameter source: raw constraint data
    /// - Returns: Target view ID as String
    private func parseTargetViewId (source : Any) -> String?
    {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return self.valueForArgument(withModCharacter: EverLayoutConstraintJSONParser.MOD_TARGET_VIEW, argumentString: source.rhs)
    }
    
    /// Name of target view. This will strip the mod character and the superclass if it's present
    ///
    /// - Parameter source: raw constraint data
    /// - Returns: Name of the target view as a string
    private func parseTargetViewName (source : Any) -> String?
    {
        guard var targetViewId = self.parseTargetViewId(source: source) else { return nil }
        
        // The target view id may contain a right side attribute, we need to strip it
        if let index = targetViewId.characters.index(of: EverLayoutConstraintJSONParser.VIEW_ATTRIBUTE_SEPARATOR)
        {
            targetViewId = targetViewId.substring(to: index)
        }
        
        return targetViewId
    }
    
    /// Parse left hand attributes from constraint data
    ///
    /// - Parameter source: raw constraint data
    /// - Returns: Array of NSLayoutAttribute
    func leftSideAttributes (source: Any) -> [NSLayoutAttribute?]?
    {
        guard let source = self.parseSource(source: source) else { return nil }
        
        // Left hand attributes are noted in the LHS and are separated by ATTRIBUTE_SEPARATOR
        guard let comps = self.parseArguments(fromString: source.lhs) else { return nil }
        
        var attrs = [NSLayoutAttribute]()
        
        for comp in comps
        {
            if let attr = EverLayoutConstraintJSONParser.ATTRIBUTE_KEYS[comp]
            {
                attrs.append(attr)
            }
            else if let attr = EverLayoutConstraintJSONParser.COMPOUND_ATTRIBUTE_KEYS[comp]
            {
                attrs.append(contentsOf: attr)
            }
        }
        
        return attrs
    }
    
    /// Parse relation from constraint data
    ///
    /// - Parameter source: raw constraint data
    /// - Returns: NSLayoutRelation
    func relation (source: Any) -> NSLayoutRelation?
    {
        guard let source = self.parseSource(source: source) else { return nil }
        
        // Relation is noted in the right hand side by the MOD_RELATION character
        if let relation = self.valueForArgument(withModCharacter: EverLayoutConstraintJSONParser.MOD_RELATION, argumentString: source.rhs)
        {
            return EverLayoutConstraintJSONParser.RELATION_KEYS[relation]
        }
        
        return nil
    }
    
    /// Parse constant from constraint data
    ///
    /// - Parameter source: raw constraint data
    /// - Returns: EverLayotuConstraintConstant
    func constant (source: Any) -> EverLayoutConstraintConstant?
    {
        guard let source = self.parseSource(source: source) else { return nil }
        
        let availableSigns = [EverLayoutConstraintJSONParser.MOD_POSITIVE_CONST , EverLayoutConstraintJSONParser.MOD_NEGATIVE_CONST , EverLayoutConstraintJSONParser.MOD_INSET_CONST , EverLayoutConstraintJSONParser.MOD_OFFSET_CONST]
        
        if let (mod , value) = self.valueForArgument(withModCharacters: availableSigns, argumentString: source.rhs)
        {
            if let sign = EverLayoutConstraintConstantSign(rawValue: mod)
            {
                if let value = value.toCGFloat()
                {
                    return EverLayoutConstraintConstant(value: value, sign: sign)
                }
                else
                {
                    EverLayoutReporter.default.warning(message: "Invalid value for constant: \(value)")
                }
            }
        }
        
        return nil
    }
    
    /// Multiplier as CGFloat
    ///
    /// - Parameter source: raw constraint data
    /// - Returns: CFloat for multiplier
    func multiplier (source: Any) -> EverLayoutConstraintMultiplier?
    {
        guard let source = self.parseSource(source: source) else { return nil }
        
        let availableSigns = [EverLayoutConstraintJSONParser.MOD_MULTIPLIER , EverLayoutConstraintJSONParser.MOD_DIVIDER]
        
        if let (mod , value) = self.valueForArgument(withModCharacters: availableSigns, argumentString: source.rhs)
        {
            if let sign = EverLayoutConstratintMultiplierSign(rawValue: mod)
            {
                if let value = value.toCGFloat()
                {
                    return EverLayoutConstraintMultiplier(value: value, sign: sign)
                }
            }
        }
        
        return nil
    }
    
    /// The constraint priority as a CGFloat
    ///
    /// - Parameter source: raw constraint data
    /// - Returns: CGFloat for constraint priority
    func priority (source: Any) -> CGFloat?
    {
        guard let source = self.parseSource(source: source) else { return nil }
        
        if let priorityString = self.valueForArgument(withModCharacter: EverLayoutConstraintJSONParser.MOD_PRIORITY, argumentString: source.rhs)
        {
            if let double = Double(priorityString)
            {
                return CGFloat(double)
            }
        }
        
        return nil
    }
    
    /// Get the attribute that the the left side attributes are being compared to
    ///
    /// - Parameter source: raw constraint data
    /// - Returns: NSLayoutAttribute
    func rightSideAttribute (source: Any) -> NSLayoutAttribute?
    {
        guard let targetView = self.parseTargetViewId(source: source) else { return nil }
        
        // A right side attribute is noted by appending the attribute name to the end of the target view's ID using 
        // VIEW_ATTRIBUTE_SEPARATOR
        if let index = targetView.characters.index(of: EverLayoutConstraintJSONParser.VIEW_ATTRIBUTE_SEPARATOR)
        {
            let attributeName = targetView.substring(from: targetView.index(after: index))
            
            return EverLayoutConstraintJSONParser.ATTRIBUTE_KEYS[attributeName]
        }
        
        return nil
    }
    
    /// Get the name of the view to equate with this constraint
    ///
    /// - Parameter source: raw constraint data
    /// - Returns: Name of view
    func comparableViewReference (source: Any) -> String?
    {
        return self.parseTargetViewName(source: source)
    }
}
