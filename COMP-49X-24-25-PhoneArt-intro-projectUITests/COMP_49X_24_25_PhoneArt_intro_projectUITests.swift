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
    func testCommentView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // First create a post to comment on
        let postTextField = app.textFields["Share your thoughts here..."]
        postTextField.tap()
        postTextField.typeText("Test post")
        
        let postButton = app.buttons["Post"]
        postButton.tap()
        
        // Verify Comment button exists
        let commentButton = app.buttons["Comments"]
        XCTAssertTrue(commentButton.exists)
        
        // Test tapping the Comment button
        commentButton.tap()
        
        // Verify the Comment View is displayed
        let commentTextField = app.textFields["Add Comment..."]
        XCTAssertTrue(commentTextField.exists)
        
        // Test entering text in the comment field
        commentTextField.tap()
        commentTextField.typeText("This is a test comment")
        XCTAssertEqual(commentTextField.value as? String, "This is a test comment")
        
        // Verify Comment button exists in the Comment View
        let commentSubmitButton = app.buttons["Comment"]
        XCTAssertTrue(commentSubmitButton.exists)
        
        // Test tapping the Comment button
        commentSubmitButton.tap()
    }

    @MainActor 
    func testDeletePost() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Create a post first
        let postTextField = app.textFields["Share your thoughts here..."]
        postTextField.tap()
        postTextField.typeText("Post to delete")
        
        let postButton = app.buttons["Post"]
        postButton.tap()
        
        // Verify Delete button exists
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists)
        
        // Test tapping the delete button
        deleteButton.tap()
        
    }
    
    @MainActor
    func testDeleteComment() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Create a post first
        let postTextField = app.textFields["Share your thoughts here..."]
        postTextField.tap()
        postTextField.typeText("Post with comment")
        
        let postButton = app.buttons["Post"]
        postButton.tap()
        
        // Navigate to comment view
        let commentButton = app.buttons["Comments"]
        commentButton.tap()
        
        // Add a comment
        let commentTextField = app.textFields["Add Comment..."]
        commentTextField.tap()
        commentTextField.typeText("Comment to delete")
        
        let commentSubmitButton = app.buttons["Comment"]
        commentSubmitButton.tap()
        
        // Verify Delete button exists for comment
        let deleteCommentButton = app.buttons["Delete"]
        XCTAssertTrue(deleteCommentButton.exists)
        
        // Test tapping the delete button
        deleteCommentButton.tap()
        
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
