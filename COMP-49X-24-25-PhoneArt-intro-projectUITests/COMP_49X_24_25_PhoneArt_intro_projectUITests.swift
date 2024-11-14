//
//  COMP_49X_24_25_PhoneArt_intro_projectUITests.swift
//  COMP-49X-24-25-PhoneArt-intro-projectUITests
//
//  Created by Aditya Prakash on 11/9/24.
//

import XCTest

final class COMP_49X_24_25_PhoneArt_intro_projectUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testTitleView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify the "Discussions" title exists
        XCTAssertTrue(app.staticTexts["Discussions"].exists)
    }
    
    @MainActor
    func testPostCreationView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify text field exists with correct placeholder
        let textField = app.textFields["Share your thoughts here..."]
        XCTAssertTrue(textField.exists)
        
        // Test entering text in the field
        textField.tap()
        textField.typeText("Test comment")
        XCTAssertEqual(textField.value as? String, "Test comment")
        
        // Verify Post button exists
        let postButton = app.buttons["Post"]
        XCTAssertTrue(postButton.exists)
        
        // Test tapping the post button
        postButton.tap()
    }

    @MainActor
    func testDeleteButtonsExist() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Create a post to test post delete button
        let postTextField = app.textFields["Share your thoughts here..."]
        postTextField.tap()
        postTextField.typeText("Test Post")
        app.buttons["Post"].tap()
        
        // Verify post delete button exists
        XCTAssertTrue(app.buttons["Delete"].exists, "Post delete button should exist")
        
        // Navigate to comments and create a comment to test comment delete button
        app.buttons["Comments"].tap()
        let commentTextField = app.textFields["Add Comment..."]
        commentTextField.tap()
        commentTextField.typeText("Test Comment")
        app.buttons["Comment"].tap()
        
        // Verify comment delete button exists
        XCTAssertTrue(app.buttons["Delete"].exists, "Comment delete button should exist")
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    
}
