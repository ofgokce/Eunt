# What is Eunt?
========

[![CocoaPods Version](https://img.shields.io/cocoapods/v/Eunt.svg?style=flat)](http://cocoapods.org/pods/Eunt)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/cocoapods/l/Eunt.svg?style=flat)](http://cocoapods.org/pods/Eunt)
[![Platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](http://cocoapods.org/pods/Eunt)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)

Eunt is a framework written for Swift UIKit which allows you to easily route from one screen to another.

## Features

- Eunt provides a way to separate the creation and navigation logic of view controllers. You can create a map of your scenes, which ones are owned by which ones and how to route to one. It is compatible with dependency injection.

- Create a map of your app using the new result builders.

- Separate the creation logic of your view controllers (and view models).

- Route easily from one scene to another.

## Requirements

- iOS 13.0+
- Xcode 13+
- Swift 5.5+
- CocoaPods 1.1.1+ (if used)

## Installation

Eunt is available through [CocoaPods](https://cocoapods.org) and [Swift Package Manager](https://swift.org/package-manager/).

### CocoaPods

To install Eunt with CocoaPods, add the following lines to your `Podfile`.

```ruby
source 'https://cdn.cocoapods.org/'
platform :ios, '9.0'
use_frameworks!

pod 'Eunt'

```

Then run `pod install` command. For details of the installation and usage of CocoaPods, visit [its official website](https://cocoapods.org).

### Swift Package Manager

in `Package.swift` add the following:

```swift
dependencies: [
    ...
    .package(url: "https://github.com/ofgokce/Eunt.git", from: "1.0.0")
],
targets: [
    .target(
        name: "MyProject",
        dependencies: [..., "Eunt"]
    )
    ...
]
```

## Basic Usage

### Create a route

A route is every UIViewController type there is, including UITabBarController and UINavigationController. 

```swift
struct HomeRoute: Routable {

    init() {
        
    }
    
    func build() -> UIViewController {
        return HomeViewController()
    }
}

extension Route {
    static var home: Route {
        Route(HomeRoute())
    }
}
```

Now your "home" route can be routed simply by calling Router's route(to:) method as:

```swift
class SomeViewController: UIViewController {
    private lazy var router: Router? = Router(origin: self, registrar: someRegistrar)
    
    ...
    
    func someFunc() {
        router.route(to: .home)
    }
}
```

And that's it!

### Register a map

For registering your app's scenes' parent-children relationship you will be using the new Swift feature @resultBuilder which is used in SwiftUI. Just create a type with conformance to the "Registrar" protocol and register your route types.

In registering keep in mind that not all routes need to be registered, only strict rules such as a tab bar controller's roots or a navigation bar's root need to be registered. Also if you have a view controller that you want it to be opened strictly in a navigation controller, that needs to be registered also. Otherwise the view controller will be presented.

The parents need to conform either "Navigator" or "Tabber" protocol, according to their function.

```swift
struct MapRegistrar: Registrar {
    var registries: [Registry] {
        register(OnboardingNavRoute.self) {
            register(OnboardingRoute.self)
        }
        register(AuthenticationRoute.self) {
            register(LoginRoute.self)
            register(SignupRoute.self)
            register(ForgotPassword.self)
        }
        register(MainTabBarRoute.self) {
            register(HomeTabNavRoute.self) {
                register(HomeRoute.self)
            }
            register(CartTabNavRoute.self) {
                register(CartRoute.self)
            }
            register(ProfileRoute.self)
        }
    }
}
```

## Notes

Feel free to contact me if you have some ideas to make this better. It will be appreciated. Most importantly, have fun!

## License

MIT license. See the [LICENSE file](LICENSE) for details.
