# Layout Data

```
	let layoutData = NSData(contentsOfFile: Bundle.main.path(forResource: "ViewController", ofType: "json", inDirectory: "Layouts")!) as! Data
	
	self.layout = EverLayout(layoutData: layoutData, layoutIndexParser: LayoutIndexJSONParser())
```

A layout is initialized with a `Data` object. Generally layout 
data would be stored in a file loaded in from the Bundle, or the layout
can be downloaded from a server.

The only requirement here is that your layout is correctly formatted for
the parser. By default, EverLayout uses a [JSON](writing.md#format) parser,
but you can make your own parsers for any language by conforming
to the different `LayoutParser` protocols.

# Building Layout

```
	self.layout!.build(onView: self.view, viewEnvironment: self)
```

Building a layout requires a root view (see [layout Index](writing.md#layout-index))
and a [View Environment](#view-environment) is optional. If left nil,
the root view will be used as the view environment.

** Note **
 - The instance of EverLayout should be strongly held.
If the layout is deallocated, EverLayout Bridge won't be able to update it.

# View Environment <a name='view-environment'></a>

A view environment is an instance of NSObject which contains the properties
referenced in the layout file. For instance, in a View Controller, you would
want the root view of your layout to be the controller's view, but the controller
itself is the object containing the other views in your layout.

```
	class ViewController : UIViewController {
		private var layout : EverLayout(...)
		public let viewInLayout : UIView = UIView()

		override func viewDidLoad () {
			super.viewDidLoad()

			self.layout!.build(onView: self.view, viewEnvironment: self)
		}
	}
```
```
{
	"name":"ViewController",
	"root":{
		"views":{
			"viewInLayout":{
				...
			}
		}
	}
}
```

In the above example, EverLayout will use the ViewController as the View Environment
and find `viewInLayout` as a property. During the build process it will
add this view to the root.

As EverLayout is looking for an NSObject as a View Environment, you can alternatively
use an NSDictionary to directly pass the views into the layout. This is
helpful when using loading layouts dynamically.

```
	let viewEnvironment : NSDictionary = [
		"viewInLayout": UIView()
	]

	self.layout?.build(onView: self , viewEnvironment: viewEnvironment)
```

** Note **
 - `NSDictionary` can be used because it is a subclass of NSObject. The Swift
 `Dictionary` is not and will not work.

** Note **
 - Properties accessed from the View Environment must be `public`, otherwise
 you will likely crash and the world will come to an end.

# View Index <a name="view-index"></a>

A View Index is created by the layout when it builds. The View Index keeps
track of all the views created in the layout and allows you to access
them after the layout has successfully built.

```
	let wrapperView = self.layout?.viewIndex.view(forKey: "wrapperView")
```

Being able to access views from the View Index is helpful when the layout is
creating new views (see [Creating Views](writing.md#creating-views))

# EverLayoutDelegate <a name="delegate"></a>

Conform to `EverLayoutDelegate` and implement 
`layout(_ layout:EverLayout , didBuildOnView: UIView)`
which is called when a layout successfully builds on a view.

** Note ** 
 - Make sure you set the `delegate` before building the layout.

# Updating Constraints <a name="updating-constraints"></a>

During runtime you may wish to update the constant or multiplier on a constraint
created in EverLayout. In `layoutDidBuild` you can access these constraints in various ways.

```
func layout(_ layout: EverLayout, didLoadOnView view: UIView) {
    if let myView = self.layout.viewIndex.viewModel(forKey: "myView") {
        if let heightConstraint = myView.getConstraints(forAttribute: .height).first {
            heightConstraint.constant = 120
        }
    }
}
```

You can target constraints belonging to a view model by both their attributes
and their identifiers.
