#JSON <a name="json"></a>
EverLayout is bundled with parsers to translate 
JSON structures in UIView hierarchies. JSON was the data structure
of choice because of its wide popularity, however if you do not wish
to use JSON you can easily implement your own data language 
by conforming to the `LayoutParser` protocols. 

Nevertheless, the following explanation of the JSON implementation
will demonstrate how EverLayout understands layouts.

** Note ** - Even though Numbers and Bools are valid data types in JSON, 
EverLayout currently only recognizes String values. This may be updated in the 
future.


# The Layout Index <a name="layout-index"></a>
The layout index is the root of every layout model.
```
{
	"name":"SimpleLayout",
	"root":{...},
	"layouts":{...}
}
```

Only 3 properties are currently read in the Layout Index:

* `name` The layout name. So far this is only used 
to route layout updates when developing with EverLayout Bridge.
* `root` Layouts are built on UIViews, which become the 'root view'
of the layout I.E This is where the layout begins.
* `layouts` EverLayout supports [sub-layouts](#sublayouts)

# The View Model <a name="view-mmodel"></a>

The view model contains layout data for individual UIViews.
```
{
	"constraints":{...},
	"properties":{...},
	"z-index":"2",
	"views":{...}
}
```

* `constraints` See [Writing Constraints](#writing-constraints)
* `properties` See [View Properties](#view-properties)
* `z-index` See [Z-Index](#z-index)
* `views` See [Subviews](#subviews)

# View Name <a name="view-name"></a>

Every view in the layout (except the root view, see [View Index](#view-index))
has a name and is expressed as a subview of another view in this layout.

```
{
	...
	"views":{
		"subviewName":{
			...
		}
	}
}
```

The key being the view's name, and the value its [view model](#view-model).

Given the sample, EverLayout would scan this layout's view environment
for a property with this name. If it finds one, it will 
map this view model to that UIView, including adding it as 
a subview.

If EverLayout is unable to find the view, it will move on.

# Creating New Views <a name="creating-views"></a>

The default behaviour for EverLayout is to find the view being referenced
by scanning the properties of its view environment. However in 
some cases you may wish to create new views from inside the layout 
file and have them become a part of your layout hierarchy.

This means:

* You can create basic views to test layout ideas without having to
re-compile (when using EverLayout Bridge).
* Views with basic functionality (like wrappers for other views)
no longer need to be described in your code.
* More sophisticated layout updates can be made without
having to update your code and re-submit your app.

If your view name is prefixed with `!`, it will be considered a
'new view' and created during the layout build.

```
{
	"!newWrapperView":{
		...
	}
}
```

# Creating New Views From UIView Subclasses <a name="creating-subclasses"></a>

In addition to being able to create new views, you can also
specify which UIView subclass you want your new view to be.

```
{
	"!newImageView:UIImageView": {
		...
	}
}
```

Append the name of your new view with `:` followed by 
a class name. In the example EverLayout creates a new 
UIImageView.

To create an instance of a custom class, you must also 
specify your application bundle ID, like so:

`!myNewClassInstance:MyApp.MyClassName`

# Writing Constraints <a name="writing-constraints"></a>

EverLayout uses AutoLayout constraints to position its elements.
The constraints for each view are generated during the layout
build based on key-value rules in the view model.

The format of these constraint rules may not immediately make sense,
and might take a while to get used to. They're based on ideas
taken from [SnapKit](https://github.com/SnapKit/SnapKit).

```
{
	"constraints":{
		"top right bottom left":"@super"
	}
}
```

The example above creates 4 NSLayoutConstraints that attach
the left, top, right and bottom attributes of this view to 
their counterparts in the superview.

```
{
	"constraints":{
		"bottom left right":"@super <8",
		"height":"@super /2"
	}
}
```

The second example creates constraints which tether the bottom, left and 
right edges to the superview with an 8 unit inset, and then gives this view a height 
of half the superview height.

Each rule is broken into left-hand and right-hand statements (key and value). Both 
statements contain arguments separated by a space " ".

For the left-hand statement, any NSLayoutAttribute is valid 
along with some additional 'compound attributes'.

* `edges` Translates to `top` `left` `right` `bottom`
* `center` Translates to `centerX` `centerY`

The right-hand statement can have many arguments, each denoted by
a modifier character.

* `@` Target a view in the layout / view environment
* `.` A dot separator can be added to a target name to specify 
an NSLayoutAttribute of that view to target (e.g `@viewName.right`)
* `+` A positive constant
* `-` A negative constant
* `<` A inset constant, which is basically a constant where `+` and `-` are inferred from content
* `*` A multiplier
* `/` A divider
* `!` Constraint identifier (for debugging)
* `%` A relation (e.g `%>=` creates a 'greater than or equal to' relation)
* `$` A constraint priority

**Note:**
EverLayout will try to infer missing constraint properties based
on the information that is supplied.

`"width": "@view +12"` Will create a constraint with the width
of `view`, plus 12 units.

`"width": "+12"` Will create a constraint that has a width of 
12 units.

# View Properties <a name="view-properties"></a>

Some properties of UIView (and its subclasses) have been made settable
in the layout files. You can set these under `properties` in the view model.

These are the properties currently available:

** UIView **

* `backgroundColor` Color can be the name of the color (`red`) or a hex 
string (`#333333`).
* `cornerRadius` Translates to `layer.cornerRadius`
* `borderWidth` Translates to `layer.borderWidth`
* `borderColor` Translates to `layer.borderColor`
* `alpha`
* `clipToBounds`
* `contentMode`

** UILabel **

* `text`
* `textColor`
* `lineBreakMode`
* `textAlignment`
* `numberOfLines`
* `fontSize`

** UIButton **

* `text` Translates to a call to setTitle(...)
* `textColor` Translates to a call to setTitleColor(...)
* `backgroundImage` Translates to a call to setBackgroundImage(...)
* `image` Translates to a call to setImage(...)

** UIImageView **

* `image` The value used is passed into UIImage(named: ...)

** UIScrollView **

* `contentInset` Value is passed into UIEdgeInsetFromString
* `contentOffset` Value is passed in CGPointFromString

# Z-Index <a name="z-index"></a>

The order in which EverLayout adds subviews is not always clear. If you
have views which overlap each other, the `z-index` can be set 
to tell EverLayout which views should be at the top.

```
{
	"onBottom": {
		"z-index":"1"
	},
	"onTop":{
		"z-index":"2"
	}
}
```
Like in CSS, the higher the `z-index` the closer to the surface the view
will be.

# Subviews <a name="subviews"></a>

Every view in the layout (except the root view) is added as a subview 
of another. Subviews are added like so:

```
{
	"constraints": {...},
	"properties":{...},
	"views":{
		"firstSubview":{
			...
		},
		"secondSubview": {
			...
		}
	}
}
```

The key is the view's name (see [view names](#view-name)), and the value
is the view model (see [view model](#view-model)).

# Sublayouts <a name="sublayouts"></a>

An EverLayout can have 'sub-layouts'.

```
{
	"name":"MainLayoutName",
	"root":{...},
	"layouts":{
		"exampleSubLayout":{
			"root": {...}
		},
		"secondSubLayout":{
			"root": {...}
		}
	}
}
```
A sub-layout has mostly the same structure as a regular layout,
except its name is its key. Technically sub-layouts can also have sub-layouts,
although I can't say I've actually tried this.

For more info on using sub-layouts, see [Reading Layouts](reading.md).

#Data Injection <a name="data-injection"></a>

'Data Injection' is a glorified 'Find and Replace' on your source layout
data. You can mark 'variables' in your layout files like so:

```
{
	"viewName":{
		"properties":{
			"backgroundColor":"#{color}"
		}
	}
}
```

Before building your layout:

```
	self.layout?.injectData([
		"color":"red"
	])
```

EverLayout will replace all instances of `#{color}` in your layout
with `red`.
