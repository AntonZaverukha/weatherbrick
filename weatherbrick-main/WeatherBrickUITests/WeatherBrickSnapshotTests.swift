//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
import SnapshotTesting

class WeatherBrickSnapshotTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    func testDefaultState() {
        let screenshot = app.screenshot().image
        assertSnapshot(matching: screenshot, as: .image(precision: 0.99, scale: nil))
    }
    
    func testInfoScreen() {
        app.buttons["INFO"].tap()
        let screenshot = app.screenshot().image
        assertSnapshot(matching: screenshot, as: .image(precision: 0.99, scale: nil))
    }
    
}
