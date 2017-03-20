//
//  LayoutTemplateJSONParser.swift
//  EverLayout
//
//  Created by Dale Webster on 18/03/2017.
//  Copyright © 2017 Dale Webster. All rights reserved.
//

import UIKit

class LayoutTemplateJSONParser: NSObject , LayoutTemplateParser {
    private func parseSource (source : Any?) -> (templateId : String , templateData : Dictionary<String , JSON>)? {
        guard let source = source as? (String , JSON) else { return nil }
        guard let templateData = source.1.dictionary else { return nil }
        
        return (templateId : source.0 , templateData : templateData)
    }
    
    func templateId(source: Any) -> String? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return source.templateId
    }
    
    func constraints(source: Any) -> [ELConstraint?]? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return LayoutViewJSONParser().viewConstraints(source: (source.0 , source.1))
    }
    
    func properties(source: Any) -> [ELViewProperty?]? {
        guard let source = self.parseSource(source: source) else { return nil }
        
        return LayoutViewJSONParser().viewProperties(source: (source.0 , source.1))
    }
}
