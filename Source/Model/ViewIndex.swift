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

public class ViewIndex: NSObject {
    /// Dictionary of every ELViewModel in the layout, with its ID as the key
    private(set) public var contents : [String : ELViewModel?] = [:]
    
    /// An array of the ELViewModels in the layout, but ordered by the Z Index
    public var contentsByZIndex : [ELViewModel?] {
        return self.contents.values.sorted { (modelA, modelB) -> Bool in
            guard let parentA = modelA?.parentModel?.id , let parentB = modelB?.parentModel?.id else { return false }
            
            if parentA == parentB {
                return (modelA?.zIndex ?? 0) < (modelB?.zIndex ?? 0)
            } else {
                return parentA < parentB
            }
        }
    }
    
    /// The view on which everything in this layout is built
    ///
    /// - Returns: Root View model
    @objc public func rootViewModel () -> ELViewModel? {
        return self.contents.first?.value
    }
    
    /// The root view's actual UIView
    ///
    /// - Returns: Root View
    @objc public func rootView () -> UIView? {
        return self.rootViewModel()?.target
    }
    
    /// Get a view by its ID in this layout
    ///
    /// - Parameter key: ID
    /// - Returns: UIView for this key
    @objc public func view (forKey key : String) -> UIView? {
        return self.contents[key]??.target
    }
    
    /// Get view model by its ID in this layout
    ///
    /// - Parameter key: ID
    /// - Returns: ELViewModel
    @objc public func viewModel (forKey key : String) -> ELViewModel? {
        if let viewModel = self.contents[key] {
            return viewModel
        }
        
        return nil
    }
    
    /// Get array of all constraints that are described by the views in this index
    ///
    /// - Returns: [ELConstraintModel]
    @objc public func getAllConstraints () -> [ELConstraintModel] {
        var allConstraints : [ELConstraintModel] = []
        
        for (_ , viewModel) in self.contents {
            let toAdd = viewModel?.getAllAffectingLayoutConstraintModels().filter({ (constraintModel) -> Bool in
                return constraintModel != nil
            }) as! [ELConstraintModel]
            
            allConstraints.append(contentsOf: toAdd)
        }
        
        return allConstraints
    }
    
    /// Add a new view mode to this index
    ///
    /// - Parameters:
    ///   - key: The ID to uniquely identify this model
    ///   - viewModel: Model to be added
    @objc public func addViewModel (forKey key : String , viewModel : ELViewModel) {
        if self.contents.keys.contains(key) {
            // Element with this key already exists in the contents
            // TODO: Throw a warning
        } else {
            self.contents[key] = viewModel
        }
    }
    
    /// Remove all models
    @objc public func clear () {
        self.contents = [:]
    }
}
