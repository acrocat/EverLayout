# Overview
EverLayout is a layout building tool for iOS. Layouts described
in JSON are parsed, interpreted and built at runtime.

** Why: **

* Create comprehensive layouts without the clumsiness of 
Interface Builder or view controllers bloated with layout code.
* Downloadable layouts - Layouts written in JSON can be downloaded
from a web server, meaning an App UI can be updated without 
having to submit for App Review.
* Build layouts with real-time update using a simple HTTP server (or [EverLayout Bridge](https://github.com/acrocat/EverLayoutBridge)).
* A/B Testing - Testing multiple UIs with your users is easy
when building a layout is just loading a file.

# Installation

EverLayout can be installed with CocoaPods.

`pod 'EverLayout'`

EverLayout Bridge is installed with Node Package Manager

`npm install -g ever-layout-bridge`

More information on EverLayout Bridge [here](https://github.com/acrocat/EverLayoutBridge)

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
which is serving it layout updates every time I save the layout file.

Every time I update the JSON, the App clears and rebuilds the 
layout with the new data.

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
