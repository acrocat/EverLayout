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

internal typealias JSON = ELJSON

/// This class is a basic clone of SwiftyJSON for easier parsing of JSON files.
/// It is limited only to the functionality that is required by this plugin
class ELJSON
{
    public var rawData : Any?
    private var parsedData : Any?
    
    init (_ data : Any) {
        self.rawData = data
        
        if let data = data as? Data
        {
            self.parsedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        }
        else
        {
            self.parsedData = data
        }
    }
    
    subscript (index : String) -> ELJSON? {
        get {
            return self.dictionary?[index]
        }
    }
    
    public var dictionary : [String : ELJSON]? {
        guard let source = self.parsedData as? [String : Any] else { return nil }
        
        var rd : [String : ELJSON] = [:]
        
        for (index , item) in source
        {
            rd[index] = ELJSON(data: item)
        }
        
        return rd
    }
    
    public var string : String? {
        return self.parsedData as? String
    }
    
    public var int : Int? {
        return self.parsedData as? Int
    }
    
    public var float : CGFloat? {
        guard let number = self.parsedData as? NSNumber else { return nil }

        return CGFloat(number.floatValue)
    }
    
    public var array : [ELJSON]? {
        guard let source = self.parsedData as? [Any] else { return nil }
        
        return source.map({ (item) -> ELJSON in
            return ELJSON(item)
        })
    }
    
    public func getRawData () -> Data? {
        guard let rawData = self.rawData else { return nil }
        
        return try? JSONSerialization.data(withJSONObject: rawData, options: .prettyPrinted)
    }
}
