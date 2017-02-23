//
//  LayoutPropertyXMLParser.swift
//  EverLayout
//
//  Created by Dale Webster on 23/02/2017.
//  Copyright © 2017 Dale Webster. All rights reserved.
//

import UIKit
import SwiftyXML

public class LayoutPropertyXMLParser : NSObject , LayoutPropertyParser {
    private func parseSource (source : Any?) -> (name : String , value : String)? {
        guard let source = source as? (String , String) else { return nil }
        
        return (
            name: source.0,
            value: source.1
        )
    }
    public func propertyName(source: Any) -> String? {
        return self.parseSource(source: source)?.name
    }
    public func propertyValue(source: Any) -> String? {
        return self.parseSource(source: source)?.value
    }
}
