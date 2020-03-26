# JSLink

PharoLink provides a mechanism for Pharo to communicate with remote Pharo processes.

- [Getting Started](#getting-started)
	- [Installation](#installation)
	- [First statements](#first-statements)
	- [Programmatic Use](#programmatic-use)
- [Garbage Collection](#garbage-collection)
- [Callbacks](#callbacks)
- [Automated Tests](#automated-tests)
- [ToDo](#todo)
- [Futures](#futures)
- [Acknowledgements and Thanks](#acknowledgements-and-thanks)


## Getting Started


### Installation

Requirements:

PharoLink has been tested with Pharo 8

To install PharoLink evaluate:

```smalltalk
EpMonitor disableDuring: [ 
Metacello new
	repository: 'github://feenkcom/Pharolink/src';
	baseline: 'PharoLink';
	load ]
```


### First statements

When first running JSLink it is worthwhile starting Pharo from the command line so you can monitor the output.

Open a playground in [Gtoolkit](https://gtoolkit.com/) and start the JSLinkApplication:

![Start PharoLink](doc/images/Start_PharoLink.png)


We can now evaluate our first expression in the remote server:

![First Object](doc/images/First_Object.png)

After typing the code in to the playground it is evaluated by pressing the play & inspect button:

![Play & Inspect button](doc/images/playinspect.png)

From here we can navigate through the attributes of the object in the same way as when inspecting pharo objects.

If the value of the attribute is a non-primitive object, a proxy will be returned, if it is a primitive, it will be returned directly:

![Inspect Primitive](doc/images/Inspect_Primitive.png)

When evaluating statements in a proxy object's playground, `this` is bound to the proxy object:

![this bound](doc/images/this_bound.png)

The node.js server can then be stopped with:

```smalltalk
JSLinkApplication stop.
```


### Programatic Use

So far we have been using a global instance of JSLink, however it is possible to have multiple servers running concurrently through the use of private instances.

For this example we'll create an Excel spreadsheet by installing and using the existing `excel4node` module.

To install the module:

```smalltalk
jslink := JSLinkApplication withDefaultSettings.
jslink start.
jslink installModule: 'excel4node'.
```

JSLink allows JavaScript code to be supplied in two ways:

1. Strings of JavaScript code, and
1. AST objects generated using the [JavaScriptGenerator package](https://github.com/feenkcom/JavaScriptGenerator/)

First, using strings:

```smalltalk
"Start JSLink"
jslink := JSLinkApplication withDefaultSettings.
jslink start.

"Ensure that the 'excel4node' module is installed."
jslink installModule: 'excel4node'

"Create the spreadsheet and worksheet"
worksheet := jslink newCommandFactory
	<< 'const excel = require(''excel4node'')';
	<< 'let workbook = new excel.Workbook()';
	<< 'let worksheet = workbook.addWorksheet(''HW'')';
	<< 'worksheet';
	sendAndWait.

"Write Hello, World!"
worksheet newCommandFactory
	<< 'this.cell(2, 2).string("Hello, World!")';
	sendAndWait.

"Save the spreadsheet"
worksheet newCommandFactory
	<< 'this.wb.write("hw.xlsx")';
	sendAndWait.

"Stop the server"
jslink stop
```

![Hello, World! with strings](doc/images/helloworld_strings.png)


Second, using JavaScript generated with `JavaScriptGenerator`:

```smalltalk
"Start JSLink"
jslink := JSLinkApplication withDefaultSettings.
jslink start.

"Ensure that the 'excel4node' module is installed."
jslink installModule: 'excel4node'

"Create the spreadsheet and worksheet"
excel := #excel asJSGIdentifier.
wb := #wb asJSGIdentifier.
ws := #ws asJSGIdentifier.
worksheet := jslink newCommandFactory
	<< (excel <- #'excel4node' require) beLetDeclaration;
	<< (wb <- (excel => #Workbook) call new) beLetDeclaration;
	<< (ws <- ((wb => #addWorksheet) callWith: { 'HW' })) beLetDeclaration;
	<< 'ws';
	sendAndWait.

"Write Hello, World!"
worksheet newCommandFactory
	<< (((#this asJSGI => #cell callWith: { 2. 2. }) => #string) callWith: { 'Hello, World!'});
	sendAndWait.

"Save the spreadsheet"
worksheet newCommandFactory
	<< ((#this asJSGI => #wb => #write) callWith: { 'hw2.xlsx' });
	sendAndWait.

"Stop the server"
jslink stop
```


![Hello, World! with JavaScriptGenerator](doc/images/helloworld_jsg.png)


## Garbage Collection

Proxy objects register them selves for finalisation.  When they are garbage collected in Pharo they are automatically removed from the registry in the node.js server.


## Callbacks

Callbacks in to Pharo from node.js are supported through observables.

See `JSLinkSendCommandTest` for examples of setting up and using callbacks.


## Automated Tests

See the 'JSLink-Tests` package.

## ToDo

`PythonBridge` supports communicating with the server using either HTTP or [MsgPack](https://msgpack.org/).  While the code has been left in the package, MsgPack is not yet supported.


## Futures

Currently JSLink is specific to node.js.  Planned future work includes adding support for the debug port in node.js, to provide better program control, and adding support for browsers, initially Chrome, using their debug port.


## Acknowledgements and Thanks

Thanks to the team at [ObjectProfile](http://www.objectprofile.com/) for making [PythonBridge](https://github.com/ObjectProfile/PythonBridge), on which JSLink is based, and to [Julien Delplanque](https://github.com/juliendelplanque) for [Python3Generator](https://github.com/juliendelplanque/Python3Generator), on which JavaScriptGenerator is based.
