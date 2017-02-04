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

extension NSObject
{
    /// Introspection, but using reflection to make it safe
    ///
    /// - Parameter key: property name to search for
    /// - Returns: The property you're looking for, or nada
    open func property (forKey key : String) -> Any?
    {
        // Use reflection to make this a safe inspection of the object
        if Mirror(reflecting: self).children.contains(where: { (property , value) -> Bool in
            return property == key
        })
        {
            return self.value(forKey: key)
        }
        else
        {
            return nil
        }
    }
}

//extension NSObject
//{
//    open func loadEverLayoutForClassName () -> EverLayout?
//    {
//        // Assume the name of the layout file to be the name of this class
//        let fileName = String(describing: self.classForCoder)
//        
//        return EverLayout(withFileName: fileName)
//    }
//}
