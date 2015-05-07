//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import UIKit
import XCTest
import SwiftRouter

class SwiftRouterTests: XCTestCase {
    
    var router = Router()
    static var parameters: [String: AnyObject]? = nil
    static var didExecuteClosure = false
    
    var mockClosure: RouteClosure = { parameters in
        SwiftRouterTests.parameters = parameters
        SwiftRouterTests.didExecuteClosure = true
    }
    
    func testWhenSpecifyingRoute_routerCanRouteIt() {
        router.addRoute("newRoute")
        
        var canRoute = router.routeURLString("newRoute")
        XCTAssert(canRoute, "Router should be able to route added route")
    }
    
    func testWhenSpecifyingRouteWithClosure_routerCanRouteIt_thenClosureIsExecuted() {
        router.addRoute("newRoute", closure: mockClosure)
        
        var canRoute = router.routeURLString("newRoute")
        XCTAssert(canRoute, "Router should be able to route added route")
        XCTAssert(SwiftRouterTests.didExecuteClosure, "Specified closure should be executed")
        XCTAssert(SwiftRouterTests.parameters == nil, "Specified closure should not return parameters")
    }
    
    func testWhenSpecifyingRouteWithParameters_routerCanRouteIt() {
        router.addRoute("newRoute", closure: mockClosure)
        
        var canRoute = router.routeURLString("newRoute?param1=value1")
        XCTAssert(canRoute, "Router should be able to route added route")
        
        var containsParameter = contains(SwiftRouterTests.parameters!.keys, "param1")
        XCTAssert(containsParameter, "returned parameters in closure should contain param1")
    }
    
}
