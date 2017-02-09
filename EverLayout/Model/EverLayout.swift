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

public class EverLayout: EverLayoutRawData
{
    public weak var delegate : EverLayoutDelegate?
    public let indexParser : EverLayoutIndexParser = EverLayoutIndexJSONParser()
    
    private(set) public var viewIndex : EverLayoutViewIndex?
    private(set) public var target : UIView?
    private(set) public var host : NSObject?
    
    public var layoutName : String? {
        return self.indexParser.layoutName(source: self.rawData)
    }
    
    public func buildLayout (onView view : UIView , host: NSObject? = nil)
    {
        self.target = view
        self.host = host ?? view
        
        self.viewIndex = EverLayoutBuilder.buildLayout(self, onView: view, host: host)
        
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
        
        if let target = self.target , let host = self.host
        {
            self.buildLayout(onView: target, host: host)
        }
    }
    
    // ---------------------------------------------------------------------------
    // ---------------------------------------------------------------------------
}







