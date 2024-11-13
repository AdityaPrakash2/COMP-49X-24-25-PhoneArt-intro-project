import XCTest
@testable import COMP_49X_24_25_PhoneArt_intro_project // Make sure this matches your module name

class PostTests: XCTestCase {
    func testPostInitialization() {
        // Given
        let content = "Test post content"
        
        // When
        let post = Post(content: content)
        
        // Then
        XCTAssertEqual(post.content, content)
        XCTAssertNotNil(post.id)
        XCTAssertNotNil(post.timestamp)
    }
}

class PostViewModelTests: XCTestCase {
    var viewModel: PostViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = PostViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddPost() {
        // Given
        let content = "Test post content"
        
        // When
        viewModel.addPost(content: content)
        
        // Then
        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts[0].content, content)
    }
    
    func testAddMultiplePosts() {
        // Given
        let contents = ["First post", "Second post", "Third post"]
        
        // When
        contents.forEach { viewModel.addPost(content: $0) }
        
        // Then
        XCTAssertEqual(viewModel.posts.count, 3)
        // Check if posts are in reverse order (newest first)
        XCTAssertEqual(viewModel.posts[0].content, contents[2])
        XCTAssertEqual(viewModel.posts[1].content, contents[1])
        XCTAssertEqual(viewModel.posts[2].content, contents[0])
    }
    
    func testPostTimestamps() {
        // Given
        let content = "Test post"
        
        // When
        let beforeDate = Date()
        viewModel.addPost(content: content)
        let afterDate = Date()
        
        // Then
        XCTAssertEqual(viewModel.posts.count, 1)
        let postTimestamp = viewModel.posts[0].timestamp
        XCTAssertTrue(beforeDate <= postTimestamp && postTimestamp <= afterDate)
    }
}

// UI Tests
class ContentViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testPostCreation() {
        // Given
        let textField = app.textFields["Share your thoughts here..."]
        let postButton = app.buttons["Post"]
        let testContent = "Test post from UI"
        
        // When
        textField.tap()
        textField.typeText(testContent)
        postButton.tap()
        
        // Then
        XCTAssertTrue(app.staticTexts[testContent].exists)
    }
    
    func testEmptyPostValidation() {
        // Given
        let textField = app.textFields["Share your thoughts here..."]
        let postButton = app.buttons["Post"]
        
        // When
        textField.tap()
        textField.typeText("   ") // Only whitespace
        postButton.tap()
        
        // Then
        // Verify the post wasn't created (no empty text elements should be visible)
        XCTAssertFalse(app.staticTexts["   "].exists)
    }
}