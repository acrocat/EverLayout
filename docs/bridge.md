# Overview

EverLayout Bridge is a small node powered simple HTTP server which monitors
layout files and sends them to the app when they've been updated.

# Installation

`npm install ever-layout-bridge`

You can get more information on EverLayout Bridge [here](https://github.com/acrocat/EverLayoutBridge)

# Connecting

When EverLayout Bridge is running, your app needs to make a connection
to it. It makes most sense to make this connection in your 
`AppDelegate`, and also a check for `DEBUG` mode might be good.

```
	#if DEBUG
	    EverLayoutBridge.connectToLayoutServer()
	#endif
```

Optionally, you can pass an IP Address and a Port number to this 
method.