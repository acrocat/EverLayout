# Overview
EverLayout is an iOS layout building tool. By default, EverLayout
can read layout data in JSON and interpret and build these layouts
entirely at runtime. 

This means:

* View controllers without layout code
* Downloadable layout files - update the app's UI without 
submitting for the App Review Process.
* Build layouts with real-time update using a simple HTTP server (or EverLayout Bridge).

# Docs

More detailed documentation [here](https://acrocat.github.io/EverLayout/).

# Installation

EverLayout can be installed with CocoaPods.

`pod 'EverLayout'`

More information on EverLayout Bridge can be found [here](https://github.com/acrocat/EverLayoutBridge)

# Simple Example

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
which is serving it layout updates ever time I save the layout file.

In the example I am just changing the properties of a UIView 
to show how layouts can be designed/built without having to re-compile
the app.

# Discussion
At the moment EverLayout is more of an experiment than a solution.
The idea was born through frustration of Interface Builder 
and the existing alternative of clunky layout code.

The goal of this project is to find a middle ground which can offer the real-time
'visual' approach of IB, and the flexibility and re-usability of
layouts described with code.

# Dependencies

At the moment EverLayout uses [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) to parse JSON files, and [Socket.IO](https://github.com/socketio/socket.io-client-swift) for communication with EverLayout Bridge.
