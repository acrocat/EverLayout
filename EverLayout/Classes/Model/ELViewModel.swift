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

public class ELViewModel: ELRawData
{
    public var viewParser : LayoutViewParser!
    
    public var id : String? {
        return self.viewParser.viewId(source: self.rawData)
    }
    public var templateClass : UIView.Type? {
        return self.viewParser.viewSuperClass(source: self.rawData)
    }
    public var constraints : [ELConstraintModel?]? {
        return self.viewParser.viewConstraints(source: self.rawData)
    }
    public var properties : [ELViewProperty?]? {
        return self.viewParser.viewProperties(source: self.rawData)
    }
    public var zIndex : Int {
        return self.viewParser.viewZIndex(source: self.rawData)
    }
    public var isNewElement : Bool {
        return self.viewParser.isNewElement(source: self.rawData)
    }
    public var subviews : [ELViewModel?]? {
        return self.viewParser.subviews(source: self.rawData)
    }
    public var templateLayouts : [String]? {
        return self.viewParser.templateLayout(source: self.rawData)
    }
    
    // Actual constraints that are created when this view is built on a view
    public var appliedConstraints : [ELConstraint] = []
    
    /// When the layout is built, the template data that this view requests is stored here
    public var appliedTemplates : [ELLayoutTemplate] = []
    
    // We cache view properties when EverLayout writes new ones, so that they can be reversed if the layout is unloaded
    public var cachedProperties : [String : String] = [:]
    
    // The view this model renders to
    public var target : UIView?
    
    // The model that this view is a child of in the index
    public var parentModel : ELViewModel?
    
    // The view is at the root of a layout file
    public var isRoot : Bool = false
    
    // When a view is removed during a layout update, we mark it inactive so it won't show but its state will be preserved
    public var isActive : Bool = true
    
    public init (rawData : Any , parser : LayoutViewParser) {
        super.init(rawData: rawData)
        
        self.viewParser = parser
    }
    
    public func update (newData : Any) {
        // Set new data
        self.rawData = newData
        
        // Mark as active again
        self.isActive = true
    }
    
    /// Toggle 'isActive' for each applied constraint depending on the new screen size
    ///
    /// - Parameter traitCollection: Trait collection to adjust constraints for
    public func updateConstraints (withTraitCollection traitCollection : UITraitCollection) {
        self.appliedConstraints.forEach { (constraint) in
            constraint.setActiveForTraitCollection(traitCollection)
        }
    }
    
    /// Get the constraints that are applied to the attribute
    ///
    /// - Parameter attribute: NSLayoutAttribute to match
    /// - Returns: Array of ELConstraints
    public func getConstraints (forAttribute attribute : NSLayoutAttribute) -> [ELConstraint] {
        return self.appliedConstraints.filter({ (constraint) -> Bool in
            return constraint.firstAttribute == attribute
        })
    }
    
    /// Get the constraints with the specified identifier
    ///
    /// - Parameter identifier: String identifier to match
    /// - Returns: Array of ELConstraints
    public func getConstraints (forIdentifier identifier : String) -> [ELConstraint] {
        return self.appliedConstraints.filter({ (constraint) -> Bool in
            return constraint.identifier == identifier
        })
    }
    
    /// Gets the constraints that are applied to atleast one of the set of attributes
    ///
    /// - Parameter attributes: Array of attributes to search
    /// - Returns: Array of ELConstraints that match
    public func getConstraints (forAttributes attributes : [NSLayoutAttribute]) -> [ELConstraint] {
        return self.appliedConstraints.filter({ (constraint) -> Bool in
            return attributes.contains(constraint.firstAttribute)
        })
    }
    
    /// Get the constraints that use at least oneo of the specified identifiers
    ///
    /// - Parameter identifiers: Array of String identifiers
    /// - Returns: Array of ELConstraints that match
    public func getConstraints (forIdentifiers identifiers : [String]) -> [ELConstraint] {
        return self.appliedConstraints.filter({ (constraint) -> Bool in
            return identifiers.contains(constraint.identifier ?? "")
        })
    }
    
    /// Affecting constraints include the constraints that are described in this view, and also the constraints that are described
    /// in the templates that this view inherits from
    ///
    /// - Returns: [ELConstraintModel?]
    public func getAllAffectingLayoutConstraintModels () -> [ELConstraintModel?] {
        var affectingModels = self.constraints ?? [ELConstraintModel?]()
        
        self.appliedTemplates.forEach { (template) in
            if let constraintModels = template.constraints {
                affectingModels.append(contentsOf: constraintModels)
            }
        }
        
        return affectingModels
    }
    
    /// Affecting properties include the properties descibed in this view, and also the properties that are described in the 
    /// templates that this view inherits from
    ///
    /// - Returns: [ELViewProperty?]
    public func getAllAffectingProperties () -> [ELViewProperty?] {
        var affectingProperties = self.properties ?? [ELViewProperty?]()
        
        self.appliedTemplates.forEach { (template) in
            if let properties = template.properties {
                affectingProperties.append(contentsOf: properties)
            }
        }
        
        return affectingProperties
    }
    
    public func remove () {
        if !self.isRoot {
            self.target?.removeFromSuperview()
        } else {
            self.target?.removeConstraints(self.appliedConstraints)
        }
        
        // Empty applied templates
        self.appliedTemplates = []
        
        // Empty the applied constraints
        self.appliedConstraints = []
        
        // Mark as inactive
        self.isActive = false
        
        // Reset the view properties to those that were cached
        self.cachedProperties.forEach { (propName , propValue) in
            let prop = ELViewProperty(rawData: (propName , propValue), parser: LayoutPropertyJSONParser())
            
            self.target?.applyViewProperty(viewProperty: prop)
        }
    }
}
