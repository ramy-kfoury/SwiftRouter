//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import Foundation

public typealias RouteClosure = ([String: AnyObject]?) -> Void

public class Router {
    
    public static var emptyClosure: RouteClosure = {
        _ in
    }
    
    public init() {}
    
    lazy var routes: [String: RouteClosure] = {
        return [String: RouteClosure]()
    }()
    
    public func addRoute(route: String, closure: RouteClosure = emptyClosure) -> Self {
        routes[route] = closure
        return self
    }
    
    public func routeURL(url: NSURL) -> Bool {
        return routeURLString(url.absoluteString)
    }
    
    public func routeURLString(urlString: String?) -> Bool {
        if let url = urlString {
            let urlComponents = split(url, maxSplit: 1, allowEmptySlices: true, isSeparator: {$0 == "?"})
            if let baseRoute = urlComponents.first where canRoute(baseRoute) {
                closureForRoute(baseRoute)(parameters(fromURLComponents: urlComponents))
                return true
            }
        }
        return false
    }
    
    private func canRoute(route: String) -> Bool {
        return contains(routes.keys, route)
    }
    
    private func closureForRoute(route: String) -> RouteClosure {
        return routes[route]!
    }
    
    private func parameters(fromURLComponents components: [String]) -> [String: AnyObject]? {
        if count(components) > 1 {
            return components.last?.parameters()
        }
        return nil
    }
    
}

private extension String {
    
    private func parameters() -> [String: AnyObject]? {
        var parameters: [String: AnyObject]?
        let keyValues = componentsSeparatedByString("&")
        if count(keyValues) > 0 {
            parameters = [String: AnyObject]()
            for pair in keyValues {
                let kv = pair.componentsSeparatedByString("=")
                if let key = kv.first, value = kv.last {
                    parameters![key] = value
                }
            }
        }
        return parameters
    }
    
}

public extension Router {
    
    static let sharedInstance = Router()
    
    
    static public func addRoute(route: String, closure: RouteClosure = emptyClosure) -> Router {
        return sharedInstance.addRoute(route, closure: closure)
    }
    
    static public func routeURL(url: NSURL) -> Bool {
        return sharedInstance.routeURL(url)
    }
    
    static public func routeURLString(urlString: String?) -> Bool {
        return sharedInstance.routeURLString(urlString)
    }
}