//
//  LayoutConstraintXMLParser.swift
//  EverLayout
//
//  Created by Dale Webster on 23/02/2017.
//  Copyright © 2017 Dale Webster. All rights reserved.
//

import UIKit
import SwiftyXML

public class LayoutConstraintXMLParser : NSObject , LayoutConstraintParser {
    private func parseSource (source : Any?) -> XML? {
        return source as? XML
    }
    public func leftSideAttributes(source: Any) -> [NSLayoutAttribute?]? {
        guard let source = self.parseSource(source: source ) else { return nil }
        
        let attributes = source.attributes["leftAttribute"]?.components(separatedBy: " ")
        
        return attributes?.map({ (attr) -> NSLayoutAttribute? in
            return LayoutConstraintJSONParser.ATTRIBUTE_KEYS[attr]
        })
    }
    public func relation(source: Any) -> NSLayoutRelation? {
        guard let source = self.parseSource(source: source) else { return nil }
        guard let relation = source.attributes["relation"] else { return nil }
        
        return LayoutConstraintJSONParser.RELATION_KEYS[relation]
    }
    public func constant(source: Any) -> ELConstraintConstant? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        if let inset = source.attributes["inset"] {
            if let float = inset.toCGFloat() {
                return ELConstraintConstant(value: float, sign: .inset)
            }
        } else if let const = source.attributes["constant"] {
            if let float = const.toCGFloat() {
                return ELConstraintConstant(value: float, sign: .positive)
            }
        }
        
        return nil
    }
    public func multiplier(source: Any) -> ELConstraintMultiplier? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        if let divide = source.attributes["divide"] {
            if let float = divide.toCGFloat() {
                return ELConstraintMultiplier(value: float, sign: .divide)
            }
        } else if let multiply = source.attributes["multiply"] {
            if let float = multiply.toCGFloat() {
                return ELConstraintMultiplier(value: float, sign: .multiply)
            }
        }
        
        return nil
    }
    public func priority(source: Any) -> CGFloat? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source.attributes["priority"]?.toCGFloat()
    }
    public func rightSideAttribute(source: Any) -> NSLayoutAttribute? {
        guard let source = self.parseSource(source: source) else { return nil }
        guard let attribute = source.attributes["rightAttribute"] else { return nil }
        
        return LayoutConstraintJSONParser.ATTRIBUTE_KEYS[attribute]
    }
    public func comparableViewReference(source: Any) -> String? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source.attributes["to"]
    }
    public func identifier(source: Any) -> String? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source.attributes["name"]
    }
}
