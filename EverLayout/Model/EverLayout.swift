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

public class EverLayout: NSObject
{
    private(set) public var layoutName : String!
    private(set) public var layoutData : Data?
    private(set) public var configuration : EverLayoutConfiguration?
    
    public let viewIndex : EverLayoutViewIndex = EverLayoutViewIndex()
    private(set) public weak var target : UIView?
    private(set) public weak var host : NSObject?
    
    private var buildable : Bool {
        return (self.target != nil) && (self.host != nil) && (self.layoutData != nil) && (self.configuration != nil)
    }
    
    public convenience init (layoutName : String , layoutData : Data , configuration : EverLayoutConfiguration = EverLayoutConfiguration.default)
    {
        self.init()
        
        self.layoutName = layoutName
        self.layoutData = layoutData
        self.configuration = configuration
        
        self.subscribeToLayoutUpdates()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Layout Updates
    // ---------------------------------------------------------------------------
    
    private func subscribeToLayoutUpdates ()
    {
        let notificationName : Notification.Name = Notification.Name("layout-update__\(self.layoutName!)")
        
        print("Listening to " + notificationName.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLayoutUpdate), name: notificationName, object: nil)
    }
    
    @objc private func didReceiveLayoutUpdate (notification : Notification)
    {
        if let layoutData = notification.object as? Data
        {
            self.layoutData = layoutData
            
            self.refresh()
        }
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Build Layout
    // ---------------------------------------------------------------------------
    
    /*
     Layout building process takes the following steps
      - Populate the view index
      - Create all UIView instances
      - Build the view hierarchy 
      - Add constraints to views
      - Add view properties
    */
    
    /// Create layout on target view
    ///
    /// - Parameters:
    ///   - view: The superview
    ///   - host: The object which contains properties referenced in the layout
    public func buildLayout (onView view : UIView , host : NSObject? = nil)
    {
        self.target = view
        self.host = host ?? view
        
        self.populateViewIndex()
        self.createTargetViews()
        self.buildViewHierarchy()
        self.addViewConstraints()
        self.addViewProperties()
    }
    
    /// Fill the viewIndex with models for each view in the layout data
    private func populateViewIndex ()
    {
        guard self.buildable else { return }
        
        func _addViewToViewIndex (viewModel : EverLayoutView , parentModel : EverLayoutView? = nil)
        {
            if let viewId = viewModel.id
            {
                viewModel.parentModel = parentModel
                
                self.viewIndex.addViewModel(forKey: viewId, viewModel: viewModel)
                
                // Add all of this views subviews to the viewIndex
                if let subviews = viewModel.subviews
                {
                    for subview in subviews
                    {
                        // Parse the view
                        if let subview = self.configuration?.viewParser.view(source: subview)
                        {
                            _addViewToViewIndex(viewModel: subview , parentModel : viewModel)
                        }
                    }
                }
            }
        }
        
        // Add the root view to the view index
        if let rootView = self.configuration?.indexParser.rootView(source: self.layoutData!)
        {
            rootView.isRoot = true
            _addViewToViewIndex(viewModel: rootView)
        }
    }
    
    /// Create actual UIView instances for each view model in the index
    private func createTargetViews ()
    {
        guard self.buildable else { return }
        
        for (viewId , viewModel) in self.viewIndex.contents
        {
            guard let viewModel = viewModel else { continue }
            
            var target : UIView?
            
            if viewModel.isRoot
            {
                viewModel.target = self.target
            }
            else
            {
                if viewModel.isNewElement
                {
                    // The target view does not exist in the host and needs to be created
                    // If the viewModel specifies a superclass, the new view should try to instantiate that
                    target = viewModel.templateClass?.init() ?? UIView()
                }
                else
                {
                    // The target view is supposed to be a property of the host.
                    if let view = self.host!.property(forKey: viewId) as? UIView
                    {
                        target = view
                    }
                    else
                    {
                        EverLayoutReporter.default.warning(message: "Unable to find target view:- \(viewId)")
                    }
                }
                
                target?.translatesAutoresizingMaskIntoConstraints = false
                viewModel.target = target
            }
        }
    }
    
    /// Add all UIView instances in the viewIndex as subviews of the target or of other models
    private func buildViewHierarchy ()
    {
        guard self.buildable else { return }
        
        for (_ , viewModel) in self.viewIndex.contents
        {
            guard let target = viewModel?.target , let parentTarget = viewModel?.parentModel?.target else { continue }
            
            parentTarget.addSubview(target)
        }
    }
    
    /// Parse constraints from layoutData and add them to the views
    private func addViewConstraints ()
    {
        guard self.buildable else { return }
        
        for (_ , viewModel) in self.viewIndex.contents
        {
            guard let constraints = viewModel?.constraints , let viewModel = viewModel else { continue }
            
            constraints.forEach({$0?.establisConstaints(onView: viewModel, withViewIndex: self.viewIndex)})
        }
    }

    private func addViewProperties ()
    {
        guard self.buildable else { return }
        
        for (_ , viewModel) in self.viewIndex.contents
        {
            guard let properties = viewModel?.properties , let viewModel = viewModel else { continue }
            
            properties.forEach({$0?.applyToView(viewModel: viewModel)})
        }
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Clear layout
    // ---------------------------------------------------------------------------
    
    /// Clear the layout on the view
    public func clear ()
    {
        self.target?.subviews.forEach({$0.removeFromSuperview()})
        
        // Clear the view index
        self.viewIndex.clear()
    }
    
    /// Clear the layout and rebuild it from layoutData
    public func refresh ()
    {
        guard let target = self.target , let host = self.host else { return }
        
        self.clear()
        self.buildLayout(onView: target, host: host)
    }
    
    // ---------------------------------------------------------------------------
    // ---------------------------------------------------------------------------
}







