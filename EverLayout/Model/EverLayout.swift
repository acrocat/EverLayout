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
    
    private(set) public var viewIndex : ViewIndex = ViewIndex()
    private(set) public var target : UIView?
    private(set) public var viewEnvironment : NSObject?
    private(set) public var injectedData : [String:String] = [:]
    
    public var layoutName : String? {
        return self.indexParser.layoutName(source: self.rawData)
    }
    public var rootView : ELView? {
        return self.indexParser.rootView(source: self.rawData)
    }
    public var layoutTemplates : [ELLayoutTemplate?]? {
        return self.indexParser.layoutTemplates(source: self.rawData)
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
        
        // Subscribe for layout updates
        if let layoutName = self.layoutName {
            self.subscribeToLayoutUpdates(forLayout: layoutName)
        }
        
        // Build the view index from the raw data
        self.updateViewIndex()
    }
    
    public func updateViewIndex () {
        func _process (_ view : ELView , parentView : ELView? = nil) {
            var viewModel : ELView! = view
            
            if view.isRoot {
                if let existingRoot = self.viewIndex.rootViewModel() {
                    existingRoot.update(newData: view.rawData)
                    
                    viewModel = existingRoot
                } else {
                    _add(view)
                }
            } else if let viewId = view.id {
                if let existingView = self.viewIndex.viewModel(forKey: viewId) {
                    existingView.update(newData: view.rawData)
                    
                    viewModel = existingView
                } else {
                    _add(view , parentView: parentView)
                }
            }
            
            if let subviews = viewModel.subviews {
                for subview in subviews {
                    guard let subview = subview else { continue }
                    
                    _process(subview , parentView: viewModel)
                }
            }
        }
        func _add (_ view : ELView , parentView : ELView? = nil) {
            if let viewId = view.id {
                view.parentModel = parentView
                
                self.viewIndex.addViewModel(forKey: viewId, viewModel: view)
            }
        }
        func _reset (_ view : ELView) {
            if let viewId = view.id {}
        }
        
        if let rootView = self.rootView {
            rootView.isRoot = true
            
            _process(rootView)
        }
    }
    
    /// Starts the process of parsing the layout data and building a view hierarchy on the view argument
    ///
    /// - Parameters:
    ///   - view: root view
    ///   - viewEnvironment: object containing UIView properties which are referenced in the layout
    public func buildLayout (onView view : UIView , viewEnvironment: NSObject? = nil) {
        self.target = view
        self.viewEnvironment = viewEnvironment ?? view
        
        // Inject data into layout
        if let rawData = self.rawData as? Data {
            self.rawData = self._injectDataIntoLayout(data: self.injectedData, layoutData: rawData)
        }
        
        // Create target views
        for (viewId , viewModel) in self.viewIndex.contents {
            guard let viewModel = viewModel , viewModel.isActive else { continue }
            
            if viewModel.isRoot {
                viewModel.target = view
            } else {
                var target : UIView?
                
                if viewModel.isNewElement {
                    // The target view does not exist in the environment so will be created as a virtual element
                    target = viewModel.templateClass?.init() ?? UIView()
                } else {
                    // The target view is supposed to be a property of the view environment.
                    if let view = viewEnvironment?.property(forKey: viewId) as? UIView {
                        target = view
                    } else {
                        ELReporter.default.warning(message: "Unable to find target view:- \(viewId)")
                    }
                }
                
                target?.translatesAutoresizingMaskIntoConstraints = false
                viewModel.target = target
            }
        }
        
        // Build view hierarchy
        // Order the view index by z-index
        let sortedIndex = viewIndex.contents.values.sorted { (modelA, modelB) -> Bool in
            guard let parentA = modelA?.parentModel?.id , let parentB = modelB?.parentModel?.id else { return false }
            
            if parentA == parentB {
                return (modelA?.zIndex ?? 0) < (modelB?.zIndex ?? 0)
            } else {
                return parentA < parentB
            }
        }
        
        for viewModel in sortedIndex {
            guard let viewModel = viewModel , let target = viewModel.target , let parentTarget = viewModel.parentModel?.target , viewModel.isActive else { continue }
            
            parentTarget.addSubview(target)
        }
        
        // Adding constraints and properties
        for (_ , viewModel) in self.viewIndex.contents {
            guard let viewModel = viewModel , viewModel.isActive else { continue }
            
            viewModel.constraints?.forEach({$0?.establisConstaints(onView: viewModel, withViewIndex: self.viewIndex)})
            viewModel.properties?.forEach({$0?.applyToView(viewModel: viewModel)})
            
            // Add constraints and properties from a template
            viewModel.templateLayouts?.forEach({ [unowned self] (layoutName) in
                if let template = self.getTemplateLayout(layoutName) {
                    if let constraints = template.constraints {
                        constraints.forEach({$0?.establisConstaints(onView: viewModel, withViewIndex: self.viewIndex)})
                    }
                    if let properties = template.properties {
                        properties.forEach({$0?.applyToView(viewModel: viewModel)})
                    }
                }
            })
        }
        
        self.delegate?.layout(self, didLoadOnView: view)
    }
    
    /// Search this layouts templates for one with the specified Id
    ///
    /// - Parameter name: Id of the template
    /// - Returns: Instance of ELLayoutTemplate if template is found
    public func getTemplateLayout (_ name : String) -> ELLayoutTemplate? {
        guard let templates = self.layoutTemplates else { return nil }
        
        if let index = templates.index(where: { (template) -> Bool in
            return template?.templateId == name
        }) {
            return templates[index]
        }
        
        return nil
    }
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Layout Updates
    // ---------------------------------------------------------------------------
    
    private func subscribeToLayoutUpdates (forLayout name : String) {
        let notificationName : Notification.Name = Notification.Name("layout-update__\(name)")
        
        print("Listening to " + notificationName.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLayoutUpdate), name: notificationName, object: nil)
    }
    
    @objc private func didReceiveLayoutUpdate (notification : Notification) {
        if let layoutData = notification.object as? Data {
            self.rawData = layoutData
            
            self.clear()
            self.updateViewIndex()
            self.reload()
        }
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Clear layout
    // ---------------------------------------------------------------------------
    
    /// Clear the layout on the view
    public func clear () {
        self.viewIndex.contents.forEach { (_ , view) in
            view?.remove()
        }
    }
    
    /// Clear the layout and rebuild it from layoutData
    public func reload () {
        if let target = self.target , let viewEnvironment = self.viewEnvironment {
            self.buildLayout(onView: target, viewEnvironment: viewEnvironment)
        }
    }
    
    // ---------------------------------------------------------------------------
    // ---------------------------------------------------------------------------
}







