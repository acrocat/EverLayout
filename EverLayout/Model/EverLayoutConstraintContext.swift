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

struct EverLayoutConstraintContext
{
    private static let INDEPENDANT_ATTRIBUTES : [NSLayoutAttribute] = [
        .width , .height
    ]
    private static let PERSPECTIVE_INSET_ATTRIBUTES : [NSLayoutAttribute] = [
        .right , .bottom , .width , .height
    ]
    private static let PERSPECTIVE_OFFSET_ATTRIBUTES : [NSLayoutAttribute] = [
        .left , .top , .width , .height
    ]
    
    var _target : UIView
    var _leftSideAttribute : NSLayoutAttribute
    var _relation : NSLayoutRelation
    var _comparableView : UIView?
    var _rightSideAttribute : NSLayoutAttribute?
    var _constant : EverLayoutConstraintConstant
    var _multiplier : EverLayoutConstraintMultiplier
    
    var target : UIView {
        return self._target
    }
    var leftSideAttribute : NSLayoutAttribute {
        return self._leftSideAttribute
    }
    var relation : NSLayoutRelation {
        return self._relation
    }
    var comparableView : UIView? {
        if self._comparableView == nil && self.rightSideAttribute != .notAnAttribute
        {
            return self.target.superview
        }
        
        return self._comparableView
    }
    var rightSideAttribute : NSLayoutAttribute? {
        if EverLayoutConstraintContext.INDEPENDANT_ATTRIBUTES.contains(self.leftSideAttribute) && self._comparableView == nil
        {
            return .notAnAttribute
        }
        
        return self._rightSideAttribute
    }
    var constant : EverLayoutConstraintConstant {
        let sign = self._constant.sign
        var value = self._constant.value
        
        // If the constant is to inset and we are using a 'perspective inset' attribute, or offset and we are using 'perspective offset' attributes
        // then we should inverse the constant. Same if it is just a negative value
        if (EverLayoutConstraintContext.PERSPECTIVE_INSET_ATTRIBUTES.contains(self.leftSideAttribute) && sign == .inset) || (EverLayoutConstraintContext.PERSPECTIVE_OFFSET_ATTRIBUTES.contains(self.leftSideAttribute) && sign == .offset) ||
            (sign == .negative)
        {
            value *= -1
        }
        
        return EverLayoutConstraintConstant(value: value, sign: sign)
    }
    var multiplier : EverLayoutConstraintMultiplier {
        let sign = self._multiplier.sign
        var value = self._multiplier.value
        
        if sign == .divide
        {
            value = 1 / value
        }
        
        return EverLayoutConstraintMultiplier(value: value, sign: sign)
    }
}
