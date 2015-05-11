//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import UIKit
import XCTest
import SwiftRouter

class SwiftRouterTests: XCTestCase {
    
    let route = "scheme://newRoute/path1/:param1/path2/:param2"
    
    var router: Router?
    static var parameters: [String: String]?
    static var didExecuteClosure: Bool?
    
    override func setUp() {
        super.setUp()
        router = Router()
        SwiftRouterTests.parameters = [String: String]()
        SwiftRouterTests.didExecuteClosure = false
    }
    
    var mockClosure: RouteClosure = { parameters in
        SwiftRouterTests.parameters = parameters
        SwiftRouterTests.didExecuteClosure = true
    }
    
    func testWhenURLIsNil_routerCantRouteIt() {
        var canRoute = router?.routeURLString(nil) ?? false
        XCTAssertFalse(canRoute, "router shouldn't route nil route")
    }
    
    func testWhenValidURLIsNotAddedBefore_routerCantRouteIt() {
        var canRoute = router?.routeURLString("scheme://route")  ?? false
        XCTAssertFalse(canRoute, "router should route valid route")
    }
    
    func testWhenValidURLAndRouteWassAddedBefore_routerCanRouteIt() {
        router?.addRoute("scheme://route", closure: mockClosure)
        var canRoute = router?.routeURLString("scheme://route")  ?? false
        XCTAssertTrue(canRoute, "router should route valid route")
    }
    
    func testWhenSpecifyingRouteWithPathParameters_routerCanRouteIt_andReturnTheParametersValues() {
        router?.addRoute(route, closure: mockClosure)
        
        router?.routeURLString("scheme://newRoute/path1/value1/path2/value2?param3=value3=")
        
        let expectedParameters = ["param1": "value1", "param2": "value2", "param3": "value3="]
        XCTAssert(expectedParameters == SwiftRouterTests.parameters!, "expected parameters should be equal to returned parameters")
    }
    
}
