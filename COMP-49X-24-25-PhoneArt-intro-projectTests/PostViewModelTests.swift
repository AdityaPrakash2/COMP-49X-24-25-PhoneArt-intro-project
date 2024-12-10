import XCTest
@testable import COMP_49X_24_25_PhoneArt_intro_project
//HEHEHEHEH 

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
  
   func testEmptyPostContent() {
       // Given
       let emptyContent = ""
      
       // When
       viewModel.addPost(content: emptyContent)
      
       // Then
       XCTAssertEqual(viewModel.posts.count, 1, "Empty posts should still be added")
   }
  
   func testWhitespaceOnlyContent() {
       // Given
       let whitespaceContent = "   \n\t   "
      
       // When
       viewModel.addPost(content: whitespaceContent)
      
       // Then
       XCTAssertEqual(viewModel.posts.count, 1, "Whitespace-only posts should still be added")
       XCTAssertEqual(viewModel.posts[0].content, whitespaceContent)
   }
  
   func testLongPostContent() {
       // Given
       let longContent = String(repeating: "a", count: 1000)
      
       // When
       viewModel.addPost(content: longContent)
      
       // Then
       XCTAssertEqual(viewModel.posts.count, 1)
       XCTAssertEqual(viewModel.posts[0].content, longContent)
   }
  
   func testSpecialCharactersInContent() {
       // Given
       let specialContent = "!@#$%^&*()_+-=[]{}|;:'\",.<>?/\\"
      
       // When
       viewModel.addPost(content: specialContent)
      
       // Then
       XCTAssertEqual(viewModel.posts.count, 1)
       XCTAssertEqual(viewModel.posts[0].content, specialContent)
   }
}



