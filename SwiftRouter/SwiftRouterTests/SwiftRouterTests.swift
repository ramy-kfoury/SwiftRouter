//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import UIKit
import XCTest
import SwiftRouter

class SwiftRouterTests: XCTestCase {
    
    var router = Router()
    static var parameters = [String: String]()
    static var didExecuteClosure = false
    static let route = "newRoute/path1/:param1/path2/:param2"
    
    var mockClosure: RouteClosure = { parameters in
        SwiftRouterTests.parameters = parameters
        SwiftRouterTests.didExecuteClosure = true
    }
    
    func testWhenURLIsNil_routerCantRouteIt() {
        var canRoute = router.routeURLString(nil)
        XCTAssert(canRoute == false, "router shouldn't route nil route")
    }
    
    func testWhenValidURLIsNotAddedBefore_routerCantRouteIt() {
        var canRoute = router.routeURLString(SwiftRouterTests.route)
        XCTAssert(canRoute == false, "router shouldn't route nil route")
    }
    
    func testWhenSpecifyingRouteWithPathParameters_routerCanRouteIt_andReturnTheParametersValues() {
        router.addRoute(SwiftRouterTests.route, closure: mockClosure)
        
        let canRoute = router.routeURLString("newRoute/path1/value1/path2/value2?param3=value3")
        XCTAssert(canRoute, "Router should be able to route added route")
        
        let expectedParameters = ["param1": "value1", "param2": "value2", "param3": "value3"]
        XCTAssert(expectedParameters == SwiftRouterTests.parameters, "expected parameters should be equal to returned parameters")
    }
    
}
