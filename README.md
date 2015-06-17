[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# SwiftRouter

A Swift Router Implementation.

## Requirements

- iOS 8+
- Xcode 6.3+

## Installation

You can use [Carthage](https://github.com/Carthage/Carthage):

```ogdl
github "ramy-kfoury/SwiftRouter"
```

or [CocoaPods](http://cocoapods.org):

```ruby
pod 'SwiftMessageBar'
```

## Usage

To use the router, first create an instance of it in your AppDelegate class, and then update the following method:

```swift
func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return router.routeURL(url)
    }
```

Adding a route requires only a route parameter, and a closure to implement your action 

```swift
addRoute(yourCustomRoute) { [unowned self] parameters in
            // present a view controller or anything you like to do when this route is detected
        }
```
The closure returns to you the parsed parameters, which can be either path parameters or query parameters. Here's an example:

```swift
route = scheme://host/path/parameter1/value1?parameter2=value2
parameters = [
"parameter1": "value1"
"parameter2": "value2"
]
```

To call a route from anywhere in your app:
```swift
UIApplication.sharedApplication().openURL(URL)
```

## Licence

SwiftRouter is released under the MIT license. See LICENSE for details


