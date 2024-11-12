//
//  COMP_49X_24_25_PhoneArt_intro_projectUITestsLaunchTests.swift
//  COMP-49X-24-25-PhoneArt-intro-projectUITests
//
//  Created by Aditya Prakash on 11/9/24.
//

import XCTest

final class COMP_49X_24_25_PhoneArt_intro_projectUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Verify the "Discussions" title exists
        XCTAssertTrue(app.staticTexts["Discussions"].exists)
        
        // Verify text field exists with correct placeholder
        let textField = app.textFields["Share your thoughts here..."]
        XCTAssertTrue(textField.exists)
        
        // Test entering text in the field
        textField.tap()
        textField.typeText("Test comment")
        XCTAssertEqual(textField.value as? String, "Test comment")
        
        // Verify Post button exists and tap it
        let postButton = app.buttons["Post"]
        XCTAssertTrue(postButton.exists)
        postButton.tap()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
