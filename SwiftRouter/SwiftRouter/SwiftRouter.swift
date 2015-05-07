//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import Foundation

public class Router {
    
    public typealias RouteClosure = () -> ()
    
    public static var emptyClosure: RouteClosure = {}
    
    public init() {}
    
    lazy var routes: [String: RouteClosure] = {
        return [String: RouteClosure]()
    }()
    
    public func numberOfRoutes() -> Int {
        return count(routes)
    }
    
    public func addRoute(route: String, closure: RouteClosure = emptyClosure) -> Self {
        routes[route] = closure
        return self
    }
    
    public func closureForRoute(route: String) -> RouteClosure {
        return routes[route]!
    }
    
    public func routeURL(url: NSURL) -> Bool {
        return routeURLString(url.absoluteString)
    }
    
    public func routeURLString(urlString: String?) -> Bool {
        if let url = urlString {
            var canRoute = contains(routes.keys, url)
            var closure = routes[url]
            closure?()
            return canRoute
        }
        return false
    }
}

public extension Router {
    
    static let sharedInstance = Router()
    
    
    static public func numberOfRoutes() -> Int {
        return sharedInstance.numberOfRoutes()
    }
    
    static public func addRoute(route: String, closure: RouteClosure = emptyClosure) -> Router {
        return sharedInstance.addRoute(route, closure: closure)
    }
    
    static public func closureForRoute(route: String) -> RouteClosure {
        return sharedInstance.routes[route]!
    }
    
    static public func routeURL(url: NSURL) -> Bool {
        return sharedInstance.routeURL(url)
    }
    
    static public func routeURLString(urlString: String?) -> Bool {
        return sharedInstance.routeURLString(urlString)
    }
}