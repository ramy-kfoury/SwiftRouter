//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import Foundation

public typealias RouteParameters = [String: String]

func += <K, V> (inout lhs: [K: V], rhs: [K: V]?) {
    if let right = rhs {
        for (k, v) in right {
            lhs[k] = v
        }
    }
}

private struct Route {
    var pattern: String?
    var pathParameters: RouteParameters?
}

public typealias RouteClosure = (RouteParameters) -> Void

public class Router {
    
    public init() {}
    
    lazy var routes: [String: RouteClosure] = {
        return [String: RouteClosure]()
    }()
    
    public func addRoute(route: String, closure: RouteClosure) -> Self {
        routes[route] = closure
        return self
    }
    
    public func routeURL(url: NSURL) -> Bool {
        return routeURLString(url.absoluteString)
    }
    
    public func routeURLString(urlString: String?) -> Bool {
        if let url = urlString {
            let urlComponents = url.componentsSeparatedByString("?")
            if let baseURL = urlComponents.first {
                if let route = findRoute(forURL: baseURL) {
                    var parameters = RouteParameters()
                    parameters += route.pathParameters
                    parameters += queryParameters(fromURLComponents: urlComponents)
                    closure(forPattern: route.pattern)?(parameters)
                    return true
                }
            }
        }
        return false
    }
    
    private func closure(forPattern pattern: String?) -> RouteClosure? {
        if let route = findRoute(forURL: pattern) {
            return routes[route.pattern!]!
        }
        return nil
    }
    
    private func canRoute(URL url: String) -> Bool {
        return findRoute(forURL: url) != nil
    }
    
    private func findRoute(forURL url: String? = nil) -> Route? {
        if url == nil {
            return nil
        }
        let routeURL = url!
        for routePattern in routes.keys {
            if routeURL ~= routePattern {
                return Route(pattern: routePattern, pathParameters: nil)
            }
            var routePatternPaths = routePattern.componentsSeparatedByString("/")
            if canMatch(routeURL, fromPaths: routePatternPaths) {
                var parameters = pathParameters(forURL: routeURL, fromPatternPaths: routePatternPaths)
                return Route(pattern: routePattern, pathParameters: parameters)
            }
        }
        return nil
    }
    
    private func pathParameters(forURL routeURL: String, fromPatternPaths patternPaths: [String]) -> RouteParameters {
        var parameters = RouteParameters()
        var routePaths = routeURL.componentsSeparatedByString("/")
        for i in 0..<count(routePaths) {
            var pattern = patternPaths[i]
            if pattern.hasPrefix(":") {
                pattern = pattern.substringFromIndex(advance(pattern.startIndex, 1))
                parameters[pattern] = routePaths[i]
            }
        }
        return parameters
    }
    
    private func canMatch(pattern: String, fromPaths patternPaths: [String]) -> Bool {
        let modifiedRoutePatternPaths: [String] = patternPaths.map { $0.hasPrefix(":") ? "\\w+" : $0 }
        let regexPattern = join("/", modifiedRoutePatternPaths)
        let regex = NSRegularExpression(pattern: regexPattern, options: .CaseInsensitive, error: nil)
        if let matches = regex?.matchesInString(pattern, options: .allZeros, range: NSMakeRange(0, count(pattern))) {
            return !matches.isEmpty
        }
        return false
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
    
    static public func addRoute(route: String, closure: RouteClosure) -> Router {
        return sharedInstance.addRoute(route, closure: closure)
    }
    
    static public func routeURL(url: NSURL) -> Bool {
        return sharedInstance.routeURL(url)
    }
    
    static public func routeURLString(urlString: String?) -> Bool {
        return sharedInstance.routeURLString(urlString)
    }
}