//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import Foundation

public typealias RouteParameters = [String: String]

func += <K, V> (lhs: inout [K: V], rhs: [K: V]?) {
    guard let rhs = rhs else { return }
    for (k, v) in rhs {
        lhs[k] = v
    }
}

private struct Route {
    var pattern: String?
    var pathParameters: RouteParameters?
}

public typealias RouteClosure = (RouteParameters) -> Void

open class Router {
    
    private var routes: [String: RouteClosure] = [:]
  
    public init() {}
  
    @discardableResult
    open func addRoute(_ route: String, closure: @escaping RouteClosure) -> Self {
        routes[route] = closure
        return self
    }
  
    @discardableResult
    open func routeURL(_ url: URL) -> Bool {
        return routeURLString(url.absoluteString)
    }
  
    @discardableResult
    open func routeURLString(_ urlString: String?) -> Bool {
        guard let urlString = urlString,
              let components = URLComponents(string: urlString),
              let scheme = components.scheme,
              let host = components.host else { return false }

        let baseURL = scheme + "://" + host + components.path

        if let route = findRoute(forURL: baseURL) {
            var parameters = RouteParameters()
            parameters += route.pathParameters
            parameters += queryItems(fromComponents: components)
            closure(forPattern: route.pattern)?(parameters)
            return true
        }
        return false
    }
  
    private func queryItems(fromComponents components: URLComponents) -> [String: String] {
        guard let queryItems = components.queryItems else { return [:] }
        return queryItems.filter { $0.value != nil }.reduce([:]) { acc, item in
            var ret = acc
            ret[item.name] = item.value
            return ret
        }
    }

    private func closure(forPattern pattern: String?) -> RouteClosure? {
        if let pattern = pattern, let route = findRoute(forURL: pattern), let routePattern = route.pattern {
            return routes[routePattern]
        }
        return nil
    }
  
    private func findRoute(forURL url: String) -> Route? {
        for routePattern in routes.keys {
            if url == routePattern {
                return Route(pattern: routePattern, pathParameters: nil)
            }
            let routePatternPaths = routePattern.components(separatedBy: "/")
            if canMatch(url, fromPaths: routePatternPaths) {
                let parameters = pathParameters(forURL: url, fromPatternPaths: routePatternPaths)
                return Route(pattern: routePattern, pathParameters: parameters)
            }
        }
        return nil
    }
    
    private func pathParameters(forURL routeURL: String, fromPatternPaths patternPaths: [String]) -> RouteParameters {
        var parameters = RouteParameters()
        var routePaths = routeURL.components(separatedBy: "/")
        for i in 0..<routePaths.count {
            if patternPaths[i].hasPrefix(":") {
                var pattern = patternPaths[i]
                pattern.remove(at: pattern.startIndex)
                parameters[pattern] = routePaths[i]
            }
        }
        return parameters
    }

    private func canMatch(_ pattern: String, fromPaths patternPaths: [String]) -> Bool {
        let regexPattern = patternPaths.map { $0.hasPrefix(":") ? "\\w+" : $0 }.joined(separator: "/")
        let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
        if let matches = regex?.matches(in: pattern, options: [], range: NSMakeRange(0, pattern.characters.count)) {
            return !matches.isEmpty
        }
        return false
    }
  
    open static let sharedInstance = Router()
  
    @discardableResult
    class open func addRoute(_ route: String, closure: @escaping RouteClosure) -> Router {
        return sharedInstance.addRoute(route, closure: closure)
    }
  
    @discardableResult
    class open func routeURL(_ url: URL) -> Bool {
        return sharedInstance.routeURL(url)
    }
  
    @discardableResult
    class open func routeURLString(_ urlString: String?) -> Bool {
        return sharedInstance.routeURLString(urlString)
    }
    
}
