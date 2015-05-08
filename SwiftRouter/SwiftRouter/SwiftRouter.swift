//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import Foundation

public typealias RouteParameters = [String: String]

func += <K, V> (inout left: [K: V], right: [K: V]?) {
    if right == nil {
        return
    }
    for (k, v) in right! {
        left.updateValue(v, forKey: k)
    }
}

struct Route {
    var pattern: String?
    var parameters: RouteParameters?
}

public typealias RouteClosure = (RouteParameters) -> Void

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
            let urlComponents = url.componentsSeparatedByString("?")
            if let baseRoute = urlComponents.first
                where canRoute(baseRoute) {
                var route = pattern(forRoute: baseRoute)
                var parameters = RouteParameters()
                parameters += route?.parameters
                parameters += queryParameters(fromURLComponents: urlComponents)
                closureForRoute(baseRoute)(parameters)
                return true
            }
        }
        return false
    }
    
    private func closureForRoute(route: String) -> RouteClosure {
        if let route = pattern(forRoute: route) {
            return routes[route.pattern!]!
        }
        return Router.emptyClosure
    }
    
    private func canRoute(route: String) -> Bool {
        return pattern(forRoute: route) != nil
    }
    
    private func pattern(forRoute route: String) -> Route? {
        for routePattern in routes.keys {
            if route ~= routePattern {
                return Route(pattern: routePattern, parameters: nil)
            }
            var routePatternPaths = routePattern.componentsSeparatedByString("/")
            var fields = routePatternPaths.filter { $0.hasPrefix(":") }
            var routePatternPathsNew: [String] = routePatternPaths.map {
                if $0.hasPrefix(":") {
                    return "\\w+"
                }
                return $0
            }
            let pattern = join("/", routePatternPathsNew)
            let regex = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: nil)
            let range = NSMakeRange(0, count(route))
            let matches = regex?.matchesInString(route, options: .allZeros, range: range) as! [NSTextCheckingResult]
            if count(matches) > 0 {
                var parameters = RouteParameters()
                var fields = route.componentsSeparatedByString("/")
                for i in 0..<count(fields) {
                    var pattern = routePatternPaths[i]
                    if pattern.hasPrefix(":") {
                        pattern = pattern.substringFromIndex(advance(pattern.startIndex, 1))
                        parameters[pattern] = fields[i]
                    }
                }
                return Route(pattern: routePattern, parameters: parameters)
            }
            return nil
        }
        return nil
    }
    
    private func queryParameters(fromURLComponents components: [String]) -> RouteParameters? {
        if count(components) > 1 {
            return components.last?.parameters()
        }
        return nil
    }
    
}

private extension String {
    
    private func parameters() -> RouteParameters {
        var parameters = RouteParameters()
        let keyValues = componentsSeparatedByString("&")
        if count(keyValues) > 0 {
            for pair in keyValues {
                let kv = pair.componentsSeparatedByString("=")
                if let key = kv.first, value = kv.last {
                    parameters[key] = value
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