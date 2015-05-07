//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import Foundation

public class Router {
    
    public init() {}
    
    lazy var routes: [String] = {
        return [String]()
    }()
    
    public func numberOfRoutes() -> Int {
        return count(routes)
    }
    
    public func addRoute(route: String) -> Self {
        routes.append(route)
        return self
    }
}