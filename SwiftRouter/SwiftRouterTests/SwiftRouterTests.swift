//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import UIKit
import XCTest
import SwiftRouter

class SwiftRouterTests: XCTestCase {
    
    var router = Router()
    static var didExecuteClosure = false
    
    var mockClosure = {
        SwiftRouterTests.didExecuteClosure = true
    }
    
    func testWhenAddingExampleRoute_matchedClosureForRouteIsNotNil() {
        router.addRoute("newRoute")
        
        var closure = router.closureForRoute("newRoute")
        XCTAssert(router.numberOfRoutes() == 1, "Pass")
        XCTAssert(closure != nil, "When not defined, closure is the EmptyClosure")
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
    }
}
