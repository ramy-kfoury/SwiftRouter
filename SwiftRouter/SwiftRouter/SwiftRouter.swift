//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import Foundation

public class Router {
    
    public typealias RouteClosure = () -> ()
    
    static var emptyClosure: RouteClosure = {}
    
    public init() {}
    
    lazy var routes: [String: RouteClosure] = {
        return [String: RouteClosure]()
    }()
    
    public func numberOfRoutes() -> Int {
        return count(routes)
    }
    
    public func addRoute(route: String, closure: RouteClosure? = emptyClosure) -> Self {
        routes[route] = closure
        return self
    }
}