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
            return contains(routes.keys, url)
        }
        return false
    }
}