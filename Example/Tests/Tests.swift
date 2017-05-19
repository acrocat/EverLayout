import UIKit
import XCTest
import EverLayout

class Tests: XCTestCase {
    var layoutData : Data!
    var layout : EverLayout!
    let rootView : UIView = UIView()
    let environmentTestView : UIView = UIView()
    
    override func setUp() {
        super.setUp()
        
        self.environmentTestView.tag = 5
        
        // Load the layout
        let bundle = Bundle(for: type(of: self))
        self.layoutData = NSData(contentsOfFile: bundle.path(forResource: "TestLayout", ofType: "json")!)! as Data
        self.layout = EverLayout(layoutData: self.layoutData!)
        
        // Build the layout
        self.layout?.build(onView: self.rootView, viewEnvironment: self)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Layout properties
    func testLayoutName () {
        XCTAssert(self.layout.layoutName == "TestLayout", "Layout name should be TestLayout")
    }
    func testRootView () {
        XCTAssertTrue(self.layout.target == self.rootView, "Root view not correctly set")
    }
    func testViewEnvironment () {
        XCTAssertTrue(self.layout.viewEnvironment == self, "View environment not set")
    }
    
    // Views
    func testNumberOfSubviews () {
        XCTAssertTrue(self.rootView.subviews.count == 3, "Incorrect number of subviews found. There are \(self.rootView.subviews.count) subviews")
    }
    func testViewFinding () {
        // Find the environment view from the ViewIndex
        let view = self.layout.viewIndex.view(forKey: "environmentTestView")
        
        // Find the view model from the ViewIndex
        let viewModel = self.layout.viewIndex.viewModel(forKey: "environmentTestView")
        
        XCTAssert(viewModel?.target == self.environmentTestView, "View model not correctly retrieved")
        XCTAssert(view == self.environmentTestView, "View not correctly retrieved")
    }
    func testEnvironmentView () {
        let view = self.layout.viewIndex.view(forKey: "environmentTestView")
        
        XCTAssertTrue(view?.tag == self.environmentTestView.tag, "The view used in the layout is not the view created in the environment.")
    }
    func testViewSuperclass () {
        let view = self.layout.viewIndex.view(forKey: "testImage")
        
        XCTAssertTrue(view is UIImageView, "The view is not subclassing UIImageView as intended")
    }
    
    // View properties
    func testViewProperties () {
        // Run tests on
        // backgroundColor
        // hidden
        // borderWidth
        // borderColor
        // alpha
        
        XCTAssertTrue(self.environmentTestView.backgroundColor == .red, "Background color has not bee set")
        XCTAssertTrue(self.environmentTestView.isHidden == true, "isHidden property is not being set")
        XCTAssertTrue(self.environmentTestView.layer.borderWidth == 3, "Border width is not being set")
        XCTAssertTrue(self.environmentTestView.layer.borderColor == UIColor.green.cgColor, "Border color is not being set")
        XCTAssertTrue(self.environmentTestView.alpha == 0.5, "Alpha is not being set")
    }
    
    // Constraints
    func testAllConstraints () {
        XCTAssertTrue(self.rootView.constraints.count == 16, "Incorrect number of constraints applied to the root view. \(self.rootView.constraints.count) applied.")
    }
    func testConstraintConstant () {
        // Width and height of the red square are 120, so the constant for those constraints should be 120
        let constraint = self.layout.viewIndex.viewModel(forKey: "redSquare")?.getConstraints(forAttribute: .height).first
        
        XCTAssertTrue(constraint?.constant == 120, "Incorrect constant applied to the height of the red square")
    }
    func testConstraintMultiplier () {
        // Multiplier of the blue square height is the super's height /4. This should result in a multiplier of 0.25
        let constraint = self.layout.viewIndex.viewModel(forKey: "blueSquare")?.getConstraints(forAttribute: .height).first
        
        XCTAssertTrue(constraint?.multiplier == 0.25, "Incorrect multiplier epplied to the height of blue square")
    }
    func testTargetView () {
        // The environmentTestView has centerX/centerY equal to that of its superview, which in this case should be the blueSquare
        let constraint = self.layout.viewIndex.viewModel(forKey: "environmentTestView")?.getConstraints(forAttribute: .centerX).first
        let blueSquare = self.layout.viewIndex.view(forKey: "blueSquare")
        
        XCTAssertTrue((constraint?.secondItem)! as! NSObject == blueSquare!, "The target for the constraint is incorrect")
    }
    
    // Templates
    func testTemplateViewProperties () {
        // blueSquare is set to inherit from 'squares' template, so should have a blue backgroundColor
        let blueSquare = self.layout.viewIndex.view(forKey: "blueSquare")
        
        XCTAssertTrue(blueSquare?.backgroundColor == .blue, "Background color from template not being inherited")
    }
    func testTemplateLayoutConstraints () {
        // The environmentTestView inherits from 'halfSuper' template which gives is a width and height equal to half that of
        // its superview
        let widthConstraint = self.layout.viewIndex.viewModel(forKey: "environmentTestView")?.getConstraints(forAttribute: .width).first
        let blueSquare = self.layout.viewIndex.view(forKey: "blueSquare")
        
        XCTAssertTrue(widthConstraint?.multiplier == 0.5 && (widthConstraint!.secondItem! as! UIView) == blueSquare, "Constraints from template not being inherited")
    }
}
