//
//  tmdbUITests.swift
//  tmdbUITests
//
//  Created by Sunil Targe on 2021/9/25.
//

import XCTest

class tmdbUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        XCUIApplication().launch()
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTableExistance() {
        app.launch()
        let table = XCUIApplication().tables
        XCTAssertNotNil(table)
    }
    
    func testNavigationBarButton_exist_for_all_devices() {
        let rightNavBarButton = XCUIApplication().navigationBars.children(matching: .button).firstMatch
        
        XCTAssert(rightNavBarButton.exists)
        XCTAssertNotNil(rightNavBarButton)
        XCTAssertTrue(rightNavBarButton.isHittable)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
