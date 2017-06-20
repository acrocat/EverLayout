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
    
    @objc private(set) public var viewIndex : ViewIndex = ViewIndex()
    @objc private(set) public var target : UIView?
    @objc private(set) public var viewEnvironment : NSObject?
    @objc private(set) public var injectedData : [String:String] = [:]
    
    @objc public var layoutName : String? {
        return self.indexParser.layoutName(source: self.rawData)
    }
    @objc public var rootView : ELViewModel? {
        return self.indexParser.rootView(source: self.rawData)
    }
    public var layoutTemplates : [ELLayoutTemplate?]? {
        return self.indexParser.layoutTemplates(source: self.rawData)
    }
    public var navigationBarProperties : [ELViewProperty?]? {
        return self.indexParser.navigationBarProperties(source: self.rawData)
    }
    @objc public var controllerTitle : String? {
        return self.indexParser.controllerTitle(source: self.rawData)
    }
    
    /// Init with layout data and a parser
    ///
    /// - Parameters:
    ///   - layoutData: Raw data for the entire layout
    ///   - layoutIndexParser: index parser to use
    public init (layoutData : Data , layoutIndexParser : LayoutIndexParser? = LayoutIndexJSONParser()) {
        super.init(rawData: layoutData)
        self.indexParser = layoutIndexParser
        
        // Subscribe for layout updates
        if let layoutName = self.layoutName {
            self.subscribeToLayoutUpdates(forLayout: layoutName)
        }
    }
    
    /// Starts the process of parsing the layout data and building a view hierarchy on the view argument
    ///
    /// - Parameters:
    ///   - view: root view
    ///   - viewEnvironment: object containing UIView properties which are referenced in the layout
    @objc public func build (onView view : UIView , viewEnvironment: NSObject? = nil) {
        // WHAT IS HAPPENING HERE:
        // 1. We assign a target view for which to build on, and a view environment for which to reference.
        // 2. If data is being injected into this layout, we need to modify our raw data to represent this. This must happen before
        // we use that raw data to build the view index.
        // 3. To build the View Index, we use our IndexParser to find the root view from the raw data. We then process this root view,
        // and recursively process its subviews and add them all to the view index. The _processViewModel function will check whether the
        // view needs to be added to the ViewIndex, or just updated it the case of a layout update. The processing will also assign each model
        // with a target UIView, which we will either find in our ViewEnvironment (if it exists), or we will init on the spot.
        // 4. We now have a ViewIndex that accurately represents all the views and layout data in our laoyut. Before we can apply the constraints
        // and properties, we must prepare the view hierarchy by adding each view as a subview to its parent model's target.
        // 5. The target and ViewIndex are ready, so we can ask the views for their constraints and then we'll apply them.
        // 6. The layout can contain properties for elements outside of the ViewIndex (navigation bar, tab bar), these properties
        // should be applied now.
        
        guard let rawData = self.rawData else { return }
        self.target = view
        self.viewEnvironment = viewEnvironment ?? view
        
        // Inject layout data
        self.rawData = self._injectDataIntoLayout(data: self.injectedData, layoutData: self.rawData as! Data)
        
        /// Determine what needs to be done with the viewmodel in the build/update process
        ///
        /// - Parameters:
        ///   - view: The view model
        ///   - parentView: The parent view model to this view model
        func _processViewModel (_ view : ELViewModel , parentView : ELViewModel? = nil) {
            var viewModel : ELViewModel! = view
            
            // Check if the view model already exists in the ViewIndex. If we're running a layout update
            // there is only need to update the existing model's data.
            
            if let viewId = viewModel.id {
                if let existingView = self.viewIndex.viewModel(forKey: viewId) {
                    // The model already exists, so its data and parent should be updated
                    existingView.update(newData: viewModel.rawData)
                    existingView.parentModel = parentView
                    
                    viewModel = existingView
                } else {
                    // The view is new, add it to the View Index
                    _addToViewIndex(view, parentView: parentView)
                }
                
                // If the view is loading properties and constraints from templates, that template data needs to be given
                // to the view
                viewModel.templateLayouts?.forEach({ (templateName) in
                    if let templateLayout = self.getTemplate(templateName) {
                        viewModel.appliedTemplates.append(templateLayout)
                    }
                })
                
                // The view is now in the View Index and up to date. The view now needs a target UIView.
                _locateTargetView(viewModel)
                
                // Apply this view's properties
                viewModel.applyAllViewProperties()
            }
            
            // Process all subviews
            if let subviews = viewModel.subviews {
                for subview in subviews {
                    guard let subview = subview else { continue }
                    
                    _processViewModel(subview , parentView: viewModel)
                }
            }
        }
        
        /// Add the view model to the View Index
        ///
        /// - Parameters:
        ///   - view: View Model to add
        ///   - parentView: The parent View Model
        func _addToViewIndex (_ view : ELViewModel , parentView : ELViewModel? = nil) {
            if let viewId = view.id {
                view.parentModel = parentView
                self.viewIndex.addViewModel(forKey: viewId, viewModel: view)
            }
        }
        
        /// Find or create the target UIView for this View Model
        ///
        /// - Parameter viewModel: View Model
        func _locateTargetView (_ viewModel : ELViewModel) {
            guard let viewId = viewModel.id , viewModel.isActive == true else { return }
            
            if viewModel.isRoot {
                viewModel.target = view
            } else {
                var target : UIView?
                
                if viewModel.isNewElement {
                    // The target view does not exist in the environment so will be created as a virtual element
                    target = viewModel.templateClass?.init() ?? UIView()
                } else {
                    // The target view is supposed to be a property of the view environment.
                    if let view = self.viewEnvironment?.property(forKey: viewId) as? UIView {
                        target = view
                    } else {
                        ELReporter.default.warning(message: "Unable to find target view:- \(viewId)")
                    }
                }
                
                target?.translatesAutoresizingMaskIntoConstraints = false
                viewModel.target = target
            }
        }
        
        // Initiate the layout build process by adding the root view to the ViewIndex
        if let rootView = self.rootView {
            rootView.isRoot = true
            
            _processViewModel(rootView)
        }
        
        // The ViewIndex is up to date and each View Model has the correct data available. Now we need to prepare the target view
        // and add each of these models as to its hierarchy
        for viewModel in self.viewIndex.contentsByZIndex {
            guard let viewModel = viewModel , let target = viewModel.target , let parentTarget = viewModel.parentModel?.target , viewModel.isActive else { continue }
            
            parentTarget.addSubview(target)
        }
        
        // Apply all constraints
        for (_ , viewModel) in self.viewIndex.contents {
            viewModel?.establishAllConstraints(inLayout: self)
        }
        
        // Add properties for navigation bar
        if let controller = self.viewEnvironment as? UIViewController {
            if let navigationBar = controller.navigationController?.navigationBar {
                self.navigationBarProperties?.forEach({ (property) in
                    property?.applyToView(view: navigationBar)
                })
            }
            
            if let title = self.controllerTitle {
                controller.title = title
            }
        }
        
        // Tell the delegate that the layout has completed the build process
        self.delegate?.layout(self, didLoadOnView: view)
    }
    
    /// Search this layouts templates for one with the specified Id
    ///
    /// - Parameter name: Id of the template
    /// - Returns: Instance of ELLayoutTemplate if template is found
    @objc public func getTemplate (_ name : String) -> ELLayoutTemplate? {
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
    @objc public func injectDataIntoLayout (data : [String : String]) {
        // Store this data so that it can be applied when the layout in created
        for (name , val) in data {
            self.injectedData[name] = val
        }
    }
    
    /// Replacing variable placeholders in the layout data with the values supplied
    private func _injectDataIntoLayout (data : [String : String] , layoutData : Data) -> Data? {
        var dataAsString = String(data: layoutData, encoding: .utf8)
        
        for (varName , value) in data {
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
            self.reload()
        }
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Manage Layout
    // ---------------------------------------------------------------------------
    
    /// Clear the layout on the view
    @objc public func clear () {
        self.viewIndex.contents.forEach { (arg) in
            
            let (_, view) = arg
            view?.remove()
        }
    }
    
    @objc public func updateConstraints (withTraitColelction traitCollection : UITraitCollection) {
        self.viewIndex.contents.forEach { (arg) in
            
            let (_, viewModel) = arg
            viewModel?.updateConstraints(withTraitCollection: traitCollection)
        }
    }
    
    @objc public func refresh () {
        for (_ , viewModel) in self.viewIndex.contents {
            viewModel?.applyAllViewProperties()
            viewModel?.establishAllConstraints(inLayout: self)
        }
    }
    
    /// Clear the layout and rebuild it from layoutData
    @objc public func reload () {
        if let target = self.target , let viewEnvironment = self.viewEnvironment {
            self.build(onView: target, viewEnvironment: viewEnvironment)
        }
    }
    
    // ---------------------------------------------------------------------------
    // ---------------------------------------------------------------------------
}







