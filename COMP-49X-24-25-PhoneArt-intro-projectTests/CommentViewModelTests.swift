import XCTest
@testable import COMP_49X_24_25_PhoneArt_intro_project

class CommentTests: XCTestCase {
    func testCommentInitialization() {
        // Given
        let content = "Test comment content"
        
        // When
        let comment = Comment(content: content)
        
        // Then
        XCTAssertEqual(comment.content, content)
        XCTAssertNotNil(comment.id)
        XCTAssertNotNil(comment.timestamp)
    }
}

class CommentViewModelTests: XCTestCase {
    var viewModel: CommentViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CommentViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddComment() {
        let content = "Test comment content"
        
        viewModel.addComment(content: content)
        
        XCTAssertEqual(viewModel.comments.count, 1)
        XCTAssertEqual(viewModel.comments[0].content, content)
    }
    
    func testAddMultipleComments() {
        let contents = ["First comment", "Second comment", "Third comment"]
        
        contents.forEach { viewModel.addComment(content: $0) }
        
        XCTAssertEqual(viewModel.comments.count, 3)

        XCTAssertEqual(viewModel.comments[0].content, contents[2])
        XCTAssertEqual(viewModel.comments[1].content, contents[1])
        XCTAssertEqual(viewModel.comments[2].content, contents[0])
    }
    
    func testCommentTimestamps() {
        let content = "Test comment"
        
        let beforeDate = Date()
        viewModel.addComment(content: content)
        let afterDate = Date()
        
        XCTAssertEqual(viewModel.comments.count, 1)
        let commentTimestamp = viewModel.comments[0].timestamp
        XCTAssertTrue(beforeDate <= commentTimestamp && commentTimestamp <= afterDate)
    }
    
    func testEmptyCommentContent() {
        let emptyContent = ""
        
        viewModel.addComment(content: emptyContent)
        
        XCTAssertEqual(viewModel.comments.count, 1, "Empty comments should still be added")
    }
    
    func testWhitespaceOnlyContent() {
        let whitespaceContent = "   \n\t   "
        
        viewModel.addComment(content: whitespaceContent)
        
        XCTAssertEqual(viewModel.comments.count, 1, "Whitespace-only comments should still be added")
        XCTAssertEqual(viewModel.comments[0].content, whitespaceContent)
    }
    
    func testLongCommentContent() {
        let longContent = String(repeating: "a", count: 1000)
        
        viewModel.addComment(content: longContent)
        
        XCTAssertEqual(viewModel.comments.count, 1)
        XCTAssertEqual(viewModel.comments[0].content, longContent)
    }
    
    func testSpecialCharactersInContent() {
        let specialContent = "!@#$%^&*()_+-=[]{}|;:'\",.<>?/\\"
        
        viewModel.addComment(content: specialContent)
        
        XCTAssertEqual(viewModel.comments.count, 1)
        XCTAssertEqual(viewModel.comments[0].content, specialContent)
    }
}
