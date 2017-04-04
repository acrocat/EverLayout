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

class LayoutConstraintJSONParser: NSObject {
    // Shared properties
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
    public static let ATTRIBUTE_SEPARATOR : Character = " "
    private static let INDEPENDANT_ATTRIBUTE_KEYS : [NSLayoutAttribute] = [
        .width,
        .height
    ]
    
    // Comprehensive properties
    public static let COMP_RELATION_KEYS : [String : NSLayoutRelation] = [
        "gte": NSLayoutRelation.greaterThanOrEqual,
        "lte": NSLayoutRelation.lessThanOrEqual
    ]
    public static let COMP_SIZE_CLASS_KEYS : [String : UIUserInterfaceSizeClass] = [
        "compact": .compact,
        "regular": .regular
    ]
    
    // Shorthand properties
    public static let SHORT_RELATION_KEYS : [String : NSLayoutRelation] = [
        "<=" : NSLayoutRelation.lessThanOrEqual,
        "=": NSLayoutRelation.equal,
        ">=": NSLayoutRelation.greaterThanOrEqual
    ]
    public static let SHORT_SIZE_CLASS_KEYS : [String : UIUserInterfaceSizeClass] = [
        "c": .compact,
        "r": .regular
    ]
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
    public static let MOD_IDENTIFIER : Character = "!"
}
