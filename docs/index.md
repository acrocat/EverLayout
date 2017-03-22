# EverLayout
EverLayout translates JSON/XML data into iOS layouts which can be downloaded, reused and updated at runtime.

## Features

* Create comprehensive layouts without the clumsiness of 
Interface Builder or view controllers bloated with layout code.
* Downloadable layouts - Layouts written in JSON can be downloaded
from a web server, meaning an App UI can be updated without 
having to submit for App Review.
* Build layouts with real-time update using a simple HTTP server (or [EverLayout Bridge](https://github.com/acrocat/EverLayoutBridge)).
* A/B Testing - Testing multiple UIs with your users is easy
when building a layout is just loading a file.

## Installation

#### Cocoapods

Add EverLayout to your `Podfile`

```
platform :ios, '8.0'
use_frameworks!
pod 'Everlayout'
```

#### Carthage

Create a Cartfile that lists the framework and run carthage update.

```
github "acrocat/EverLayout
```

#### EverLayout Bridge

EverLayout Bridge can be installed via Node Package Manager.
```
npm install -g ever-layout-bridge
```
More info [here](https://www.github.com/acrocat/everlayoutbridge)

## Usage Example
#### Layout file
```
{
	"name":"ViewController",
	"root":{
		"views":{
			"exampleButton":{
				"constraints":{
					"center":"@super",
					"width":"+120",
					"height":"+80"
				},
				"properties":{
					"text":"Tap Me!"
				}
			}
		}
	}
}
```
#### Swift
```
import UIKit
import EverLayout

class ViewController: UIViewController {
    private var layout : EverLayout?
    public let exampleButton : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layoutData = NSData(contentsOfFile: Bundle.main.path(forResource: "ViewController", ofType: "json", inDirectory: "Layouts")!) as! Data
        self.layout = EverLayout(layoutData: layoutData)
        self.layout?.buildLayout(onView: self.view, viewEnvironment: self)
    }
}
```
## Simple Example

![Basic example](http://i.imgur.com/owJonXQ.gif "Basic example")

```
{
	"name":"ViewController",
	"root":{
		"views":{
			"!redSquare":{
				"constraints": {
					"width height":"+180",
					"center":"@super <24"
				},
				"properties":{
					"backgroundColor":"red"
				}
			}
		}
	}
}
```
Here I am running a blank application in the simulator side-by-side
with a ViewController layout described in JSON, which is loaded by the default
View Controller. The app has connected to EverLayout Bridge 
which is serving it layout updates every time I save the layout file.

Every time I update the JSON, the App clears and rebuilds the 
layout with the new data.

In the example I am just changing the properties of a UIView 
to show how layouts can be designed/built without having to re-compile
the app.

## Discussion
At the moment EverLayout is more of an experiment than a solution.
The idea was born through frustration of Interface Builder 
and the existing alternative of clunky layout code.

The goal of this project is to find a middle ground which can offer the real-time
'visual' approach of IB, and the flexibility and re-usability of
layouts described with code.


## Further Reading

[Building and distributing iOS Layouts with EverLayout](https://hackernoon.com/building-and-distributing-ios-layouts-with-everlayout-c9ea41750f6#.b41s5bsh7)

## Dependencies

 EverLayout currently uses [Socket.IO](https://github.com/socketio/socket.io-client-swift)
 to communicate with the EverLayout Bridge for live update.
