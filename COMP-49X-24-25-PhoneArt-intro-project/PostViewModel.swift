import Foundation

public struct Post: Identifiable {
    public let id: UUID
    public let userId: String
    public let content: String
    public let timestamp: Date
    
    public init(id: UUID = UUID(), userId: String, content: String, timestamp: Date = Date()) {
        self.id = id
        self.userId = userId
        self.content = content
        self.timestamp = timestamp
    }
}

public class PostViewModel: ObservableObject {
    @Published public var posts: [Post] = []
    
    public init() {
        // Add some sample posts
        posts = [
            Post(userId: "admin_id", content: "Welcome to our app!"),
            Post(userId: "user1_id", content: "This is a test post from user 1"),
            Post(userId: "user2_id", content: "Hello from user 2!")
        ]
    }
    
    public func addPost(content: String, userId: String) {
        let post = Post(userId: userId, content: content)
        posts.insert(post, at: 0)
    }
    
    public func deletePost(post: Post) {
        posts.removeAll { $0.id == post.id }
    }
}


