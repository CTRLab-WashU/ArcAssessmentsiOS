 //
//  ArcTests.swift
//  ArcTests
//
//  Created by Philip Hayes on 6/24/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import XCTest
@testable import Arc
class ArcTests: XCTestCase {
	let environment = ACEnvironment()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		Arc.configureWithEnvironment(environment: environment)
    }
	
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
