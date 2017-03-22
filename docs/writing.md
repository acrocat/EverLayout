# Writing Layouts
##Format <a name="format"></a>
EverLayout uses parsers to translate layouts from JSON data. 

The following documentation demonstrates how to use EverLyout to write layouts for the default
JSON parsers, however if you're interested
in writing layouts using a different format or general structure, read <a href="/EverLayout/formats">Layout Formats</a>
to see how to write your own parsers.

## The Layout Index <a name="layout-index"></a>
The layout index is the root of every layout model.
```
{
	"name":"SimpleLayout",
	"root":{...},
	"templates":{...}
}
```

Only 3 properties are currently read in the Layout Index:

* `name` The layout name. So far this is only used 
to route layout updates when developing with EverLayout Bridge.
* `root` Layouts are built on UIViews, which become the 'root view'
of the layout I.E This is where the layout begins.
* `templates` EverLayout supports templates which are reusable throughout the entire layout.

## The View Model <a name="view-mmodel"></a>

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

## View Name <a name="view-name"></a>

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

## Creating New Views <a name="creating-views"></a>

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

## Creating New Views From UIView Subclasses <a name="creating-subclasses"></a>

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
specify your application namespace, like so:

`!myNewClassInstance:MyApp.MyClassName`

## Writing Constraints <a name="writing-constraints"></a>

EverLayout uses AutoLayout constraints to position its elements.
The constraints for each view are generated during the layout
build based on key-value rules in the view model.

The constraints are written as key-value pairs; The key denotes which attributes 
to constrain, and the value is a representation of the layout arguments to apply
to each of these attributes.

The constraint arguments can be written in comprehensive and shorthand formats.

#### Comprehensive

```
{
	"constraints":{
		"top right bottom left":{
			"to":"super"
		}
	}
}
```

#### Shorhand

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

#### Comprehensive

```
{
	"constraints":{
		"bottom left right":{
			"to":"super",
			"inset":8
		},
		"height":{
			"to":"super",
			"multiplier":0.5
		}
	}
}
```

#### Shorthand

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

In the attribute declarations (the key), and the shorthand arguments (the value), each argument
is separated by a " ".

For the left-hand statement, any NSLayoutAttribute is valid 
along with some additional 'compound attributes'.

* `edges` Translates to `top` `left` `right` `bottom`
* `center` Translates to `centerX` `centerY`

The right-hand statement can have many arguments, each denoted by
a modifier character in shorthand.

* `to` / `@` Target a view in the layout / view environment
* `attribute` / `.` A dot separator can be added to a target name to specify 
an NSLayoutAttribute of that view to target (e.g `@viewName.right`)
* `constant` / `+` / `-` A constant (positive or negative)
* `inset` / `<` An inset constant, which is basically a constant where `+` and `-` are inferred from content
* `multiplier` / `*` / `/` A multiplier or convenience divider
* `identifier` / `!` Constraint identifier (for debugging)
* `relation` / `%` A relation (e.g `%>=` creates a 'greater than or equal to' relation). Comprehensive
values are `gte` and `lte`.
* `priority` / `$` A constraint priority

**Note:**
EverLayout will try to infer missing constraint properties based
on the information that is supplied.

`"width": "@view +12"` Will create a constraint with the width
of `view`, plus 12 units.

`"width": "+12"` Will create a constraint that has a width of 
12 units.

#### Multiple constraints

Since in JSON structures a key is unique, each layout attribute can only have 
one constraint argument, which will cause problems if you wish to have multiple constraints
with different priorities or relations. To get around this the constraint arguments can be 
an array of the comprehensive and shorthand arguments described above.

```
{
	"constraints":{
		"width":[
			{
				"constant":100,
				"priority":500
			},
			{
				"constant":150,
				"priority":700
			}
		]
	}
}
```

## View Properties <a name="view-properties"></a>

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
* `hidden`

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

* `image` The value used is passed into UIImage(named: ...). If there is no local asset found,
EverLayout will check if the value is a URL and attempt to load a remote image (this is helpful 
for development, but probably not practical for production).

** UIScrollView **

* `contentInset` Value is passed into UIEdgeInsetFromString
* `contentOffset` Value is passed in CGPointFromString

** UITextField **

* `placeholder`

## Z-Index <a name="z-index"></a>

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

## Subviews <a name="subviews"></a>

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

## Templates <a name="templates"></a>

A layout can have templates to be reused.

```
{
	"name":"LayoutExample",
	"root":{
		"!buttonOne:UIButton":{
			"template":"button",
			"properties":{
				...
			},
			"constraints":{
				...
			}
		},
		"!button2:UIButton":{
			"template":"button",
			"properties":{
				...
			},
			"constraints":{
				...
			}
		}
	},
	"templates":{
		"button":{
			"properties":{
				"backgroundColor":"#333333"
			},
			"constraints":{
				"width":"+200",
				"height":"+40"
			}
		}
	}
}
```

In the example the layout is creating two new buttons that are both inheriting the same properties
from the template `button`. 

Templates currently support `properties` and `constraints`.

A view can inherit from multiple templates by passing the names into an array.

```
{
	"!myView":{
		"template":["firstTemplate" , "secondTemplate"]
	}
}
```

## Data Injection <a name="data-injection"></a>

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
