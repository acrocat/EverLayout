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

class EverLayoutBuilder: NSObject
{
    private static let configuration : EverLayoutConfiguration = EverLayoutConfiguration.default
    
    // ---------------------------------------------------------------------------
    // MARK: - Build Layout
    // ---------------------------------------------------------------------------
 
    /*
     Layout building process takes the following steps
     - Create the view index
     - Create all UIView instances
     - Build the view hierarchy
     - Add constraints to views
     - Add view properties
     */
 
    static func buildLayout (_ layout : EverLayout , onView view : UIView , host : NSObject? = nil) -> EverLayoutViewIndex
    {
        var viewIndex : EverLayoutViewIndex = self.createViewIndex(layoutData: layout.rawData)
        
        self.createTargetViews(viewIndex: &viewIndex, rootView: view, host: host ?? view)
        self.buildViewHierarchy(viewIndex: &viewIndex)
        self.addViewConstraints(viewIndex: &viewIndex)
        self.addViewProperties(viewIndex: &viewIndex)
        
        return viewIndex
    }
    
    /// Fill the viewIndex with models for each view in the layout data
    private static func createViewIndex (layoutData : Any) -> EverLayoutViewIndex
    {
        var viewIndex : EverLayoutViewIndex = EverLayoutViewIndex()
        
        func _addViewToViewIndex (viewModel : EverLayoutView , parentModel : EverLayoutView? = nil , viewIndex : inout EverLayoutViewIndex)
        {
            if let viewId = viewModel.id
            {
                viewModel.parentModel = parentModel
                
                viewIndex.addViewModel(forKey: viewId, viewModel: viewModel)
                
                // Add all of this views subviews to the viewIndex
                if let subviews = viewModel.subviews
                {
                    for subview in subviews
                    {
                        // Parse the view
                        if let subview = self.configuration.viewParser.view(source: subview)
                        {
                            _addViewToViewIndex(viewModel: subview, parentModel: viewModel, viewIndex: &viewIndex)
                        }
                    }
                }
            }
        }
        
        // Add the root view to the view index
        if let rootView = self.configuration.indexParser.rootView(source: layoutData)
        {
            rootView.isRoot = true
            _addViewToViewIndex(viewModel: rootView, viewIndex: &viewIndex)
        }
        
        return viewIndex
    }
    
    /// Create actual UIView instances for each view model in the index
    private static func createTargetViews (viewIndex : inout EverLayoutViewIndex , rootView : UIView  , host : NSObject)
    {
        for (viewId , viewModel) in viewIndex.contents
        {
            guard let viewModel = viewModel else { continue }
            
            var target : UIView?
            
            if viewModel.isRoot
            {
                viewModel.target = rootView
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
                    if let view = host.property(forKey: viewId) as? UIView
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
    private static func buildViewHierarchy (viewIndex : inout EverLayoutViewIndex)
    {
        // Order the view index by z-index
        let sortedIndex = viewIndex.contents.values.sorted { (modelA, modelB) -> Bool in
            guard let parentA = modelA?.parentModel?.id , let parentB = modelB?.parentModel?.id else { return false }
            
            if parentA == parentB
            {
                return (modelA?.zIndex ?? 0) < (modelB?.zIndex ?? 0)
            }
            else
            {
                return parentA < parentB
            }
        }
        
        for viewModel in sortedIndex
        {
            guard let viewModel = viewModel , let target = viewModel.target , let parentTarget = viewModel.parentModel?.target else { continue }
            
            parentTarget.addSubview(target)
        }
    }
    
    /// Parse constraints from layoutData and add them to the views
    private static func addViewConstraints (viewIndex : inout EverLayoutViewIndex)
    {
        for (_ , viewModel) in viewIndex.contents
        {
            guard let constraints = viewModel?.constraints , let viewModel = viewModel else { continue }
            
            constraints.forEach({$0?.establisConstaints(onView: viewModel, withViewIndex: viewIndex)})
        }
    }
    
    private static func addViewProperties (viewIndex : inout EverLayoutViewIndex)
    {
        for (_ , viewModel) in viewIndex.contents
        {
            guard let properties = viewModel?.properties , let viewModel = viewModel else { continue }
            
            properties.forEach({$0?.applyToView(viewModel: viewModel)})
        }
    }
}
