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

open class EverLayout: ELRawData
{
    public weak var delegate : EverLayoutDelegate?
    public var indexParser : LayoutIndexParser!
    
    private(set) public var viewIndex : ViewIndex?
    private(set) public var target : UIView?
    private(set) public var viewEnvironment : NSObject?
    private(set) public var injectedData : [String:String] = [:]
    
    public var layoutName : String? {
        return self.indexParser.layoutName(source: self.rawData)
    }
    public var sublayouts : [String : Any?]? {
        return self.indexParser.sublayouts(source: self.rawData)
    }
    
    /// Init with layout data and a parser
    ///
    /// - Parameters:
    ///   - layoutData: Raw data for the entire layout
    ///   - layoutIndexParser: index parser to use
    public init (layoutData : Data , layoutIndexParser : LayoutIndexParser? = LayoutIndexJSONParser())
    {
        super.init(rawData: layoutData)
        self.indexParser = layoutIndexParser
        
        if let layoutName = self.layoutName
        {
            self.subscribeToLayoutUpdates(forLayout: layoutName)
        }
    }
    
    /// Starts the process of parsing the layout data and building a view hierarchy on the view argument
    ///
    /// - Parameters:
    ///   - view: root view
    ///   - viewEnvironment: object containing UIView properties which are referenced in the layout
    public func buildLayout (onView view : UIView , viewEnvironment: NSObject? = nil)
    {
        self.target = view
        self.viewEnvironment = viewEnvironment ?? view
        
        // Inject data into layout
        if let rawData = self.rawData as? Data
        {
            self.rawData = self._injectDataIntoLayout(data: self.injectedData, layoutData: rawData)
        }
        
        self.viewIndex = EverLayoutBuilder.buildLayout(self, onView: view, viewEnvironment: viewEnvironment)
        
        self.delegate?.layout(self, didLoadOnView: view)
    }
    
    public func getSubLayout (_ name : String) -> EverLayout?
    {
        guard let layoutData = self.sublayouts?[name] as? Data else { return nil }
        
        return EverLayout(layoutData: layoutData, layoutIndexParser: self.indexParser)
    }
    
    /// Similar to building a full layout, this will begin the process of building a sublayout on the passed view
    ///
    /// - Parameters:
    ///   - name: Name of sublayout to load
    ///   - view: The root view to build this layout on
    ///   - host: An optional object which contains the properties referenced in this layout
    ///   - data: An optional dictionary of data to inject into this sublayout
//    public func buildSubLayout (_ name : String , onView view : UIView , host : NSObject? = nil , data : [String : String]? = nil)
//    {
//        guard var sublayout = self.sublayouts?[name] else { return }
//        
//        // Inject data into the sublayout
//        if var sublayout = sublayout as? Data , let data = data
//        {
//            sublayout = self._injectDataIntoLayout(data: data, layoutData: sublayout)!
//        }
//        
//        // Build!
//        EverLayoutBuilder.buildLayout(sublayout, onView: view, host: host)
//    }
    
    /// Set data to be injected when the layout is built
    ///
    /// - Parameter data: Dictionary of key-values for variables in the layout
    public func injectDataIntoLayout (data : [String : String])
    {
        // Store this data so that it can be applied when the layout in created
        for (name , val) in data
        {
            self.injectedData[name] = val
        }
    }
    
    /// Replacing variable placeholders in the layout data with the values supplied
    private func _injectDataIntoLayout (data : [String : String] , layoutData : Data) -> Data?
    {
        var dataAsString = String(data: layoutData, encoding: .utf8)
        
        for (varName , value) in data
        {
            dataAsString = dataAsString?.replacingOccurrences(of: "#{\(varName)}", with: value)
        }
        
        return dataAsString?.data(using: .utf8)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Layout Updates
    // ---------------------------------------------------------------------------
    
    private func subscribeToLayoutUpdates (forLayout name : String)
    {
        let notificationName : Notification.Name = Notification.Name("layout-update__\(name)")
        
        print("Listening to " + notificationName.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLayoutUpdate), name: notificationName, object: nil)
    }
    
    @objc private func didReceiveLayoutUpdate (notification : Notification)
    {
        if let layoutData = notification.object as? Data
        {
            self.rawData = layoutData
            
            self.refresh()
        }
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Clear layout
    // ---------------------------------------------------------------------------
    
    /// Clear the layout on the view
    public func clear ()
    {
        guard let viewIndex = self.viewIndex else { return }
        
        // As long as the viewModel isn't the root of the layout, we need to remove each view from its superview
        for (_ , viewModel) in viewIndex.contents
        {
            if viewModel?.isRoot == false { viewModel?.target?.removeFromSuperview() }
        }
        
        // Clear the view index
        viewIndex.clear()
    }
    
    /// Clear the layout and rebuild it from layoutData
    public func refresh ()
    {
        self.clear()
        
        if let target = self.target , let viewEnvironment = self.viewEnvironment
        {
            self.buildLayout(onView: target, viewEnvironment: viewEnvironment)
        }
    }
    
    // ---------------------------------------------------------------------------
    // ---------------------------------------------------------------------------
}







