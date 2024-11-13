import Foundation
import SwiftUI

// Makea the Post structure public for other files
public struct Post: Identifiable {
    public let id: UUID
    public let content: String
    public let timestamp: Date
    
    public init(content: String) {
        self.id = UUID()
        self.content = content
        self.timestamp = Date()
    }
}

// Makes the ViewModel class public and inherit from ObservableObject
public class PostViewModel: ObservableObject {
    @Published public var posts: [Post] = []
    
    // Adds explicit public initializer
    public init() {}
    
    public func addPost(content: String) {
        let post = Post(content: content)
        // Adds the new posts to the top
        posts.insert(post, at: 0)
        print("New post added: \(post.content)")
    }
}
