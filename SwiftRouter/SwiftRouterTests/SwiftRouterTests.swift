//
//  Copyright (c) 2015 Ramy Kfoury. All rights reserved.
//

import UIKit
import XCTest
import SwiftRouter

class SwiftRouterTests: XCTestCase {
    
    var router = Router()
    
    func testExample() {
        router.addRoute("newRoute")
        XCTAssert(router.numberOfRoutes() == 1, "Pass")
    }
    
}
