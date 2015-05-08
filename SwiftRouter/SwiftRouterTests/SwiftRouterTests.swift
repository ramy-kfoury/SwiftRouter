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
    
    var mockClosure: RouteClosure = { parameters in
        SwiftRouterTests.parameters = parameters
        SwiftRouterTests.didExecuteClosure = true
    }
    
    func testWhenSpecifyingRouteWithPathParameters_routeCanRouteIt_andReturnTheParametersValues() {
        router.addRoute("newRoute/path1/:param1/path2/:param2", closure: mockClosure)
        
        var canRoute = router.routeURLString("newRoute/path1/value1/path2/value2?param3=value3")
        XCTAssert(canRoute, "Router should be able to route added route")
        
        let containsParameter1 = contains(SwiftRouterTests.parameters.keys, "param1")
        let containsParameter2 = contains(SwiftRouterTests.parameters.keys, "param2")
        let containsParameter3 = contains(SwiftRouterTests.parameters.keys, "param3")
        
        let resultValue1 = SwiftRouterTests.parameters["param1"]
        let resultValue2 = SwiftRouterTests.parameters["param2"]
        let resultValue3 = SwiftRouterTests.parameters["param3"]
        
        XCTAssert(containsParameter1 && resultValue1 == "value1", "parameter1 should be equal to value1")
        XCTAssert(containsParameter2 && resultValue2 == "value2", "parameter2 should be equal to value2")
        XCTAssert(containsParameter3 && resultValue3 == "value3", "parameter3 should be equal to value3")
    }
    
}
