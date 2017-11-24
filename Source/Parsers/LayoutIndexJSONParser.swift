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

public class LayoutIndexJSONParser : NSObject , LayoutIndexParser
{
    public static let KEY_LAYOUT_NAME : String = "name"
    public static let KEY_LAYOUT_ROOT : String = "root"
    public static let KEY_TEMPLATES : String = "templates"
    public static let KEY_NAVBAR_PROPERTIES : String = "navigationBar"
    public static let KEY_TITLE : String = "controllerTitle"
    
    private func parseData (source : Any) -> [String : JSON]?
    {
        guard let source = source as? Data else { return nil }
        
        return JSON(source).dictionary
    }
    
    /// Parse the name of the layout
    ///
    /// - Parameter source: raw data of the layout
    /// - Returns: Name of layout
    public func layoutName (source : Any) -> String?
    {
        guard let source = self.parseData(source: source) else { return nil }
        
        return source[LayoutIndexJSONParser.KEY_LAYOUT_NAME]?.string
    }
    
    /// Parse the layout template blocks
    ///
    /// - Parameter source: Raw layout data
    /// - Returns: Array of ELLayoutTemplate objects
    public func layoutTemplates(source: Any) -> [ELLayoutTemplate?]? {
        guard let source = self.parseData(source: source) else { return nil }
        guard let templateData = source[LayoutIndexJSONParser.KEY_TEMPLATES]?.dictionary else { return nil }
        
        var templates : [ELLayoutTemplate?]? = []
        for (templateName , templateData) in templateData {
            templates?.append(ELLayoutTemplate(rawData: (templateName , templateData), parser: LayoutTemplateJSONParser()))
        }
        
        return templates
    }
    
    /// Parse the rootView from the raw index model
    ///
    /// - Parameter source: raw data of the layout
    /// - Returns: EverLayoutView model of the root view
    public func rootView(source: Any) -> ELViewModel?
    {
        guard let source = self.parseData(source: source) else { return nil }
        guard let viewData = source[LayoutIndexJSONParser.KEY_LAYOUT_ROOT]?.dictionary else { return nil }
        
        return ELViewModel(rawData: ("root" , viewData), parser: LayoutViewJSONParser())
    }
    
    /// Parse the rootview for properties to be applied to a navigation bar
    ///
    /// - Parameter source: raw data of the layout
    /// - Returns: Array of ELViewProperties
    public func navigationBarProperties(source: Any) -> [ELViewProperty?]? {
        guard let source = self.parseData(source: source) else { return nil }
        guard let jsonData = source[LayoutIndexJSONParser.KEY_NAVBAR_PROPERTIES]?.dictionary else { return nil }
        
        return jsonData.map({ (key , value) -> ELViewProperty? in
            guard let value = value.string else { return nil }
            
            return ELViewProperty(rawData: (key , value), parser: LayoutPropertyJSONParser())
        })
    }
    
    /// Parse the rootview for a controller title string
    ///
    /// - Parameter source: Raw layout data
    /// - Returns: String
    public func controllerTitle (source : Any) -> String? {
        guard let source = self.parseData(source: source) else { return nil }
        
        return source[LayoutIndexJSONParser.KEY_TITLE]?.string
    }
}
