import Foundation
import SwiftUI


// Structure for the comments.
public struct Comment: Identifiable {
   public let id: UUID
   public let content: String
   public let timestamp: Date
  
   public init(content: String) {
       self.id = UUID()
       self.content = content
       self.timestamp = Date()
   }
}


// Includes funtionality for the comment button so that users can add comments to the posts.
public class CommentViewModel: ObservableObject {
   @Published public var comments: [Comment] = []
   public init() {}
  
   // The function that adds the comments to the top of the list.
   public func addComment(content: String) {
       let comment = Comment(content: content)
       // Make sure that the comments are added to the top of the list.
       comments.insert(comment, at: 0)
       print("New comment added: \(comment.content)")
   }
  
   // The function that deletes comments from the list
   public func deleteComment(comment: Comment) {
       if let index = comments.firstIndex(where: { $0.id == comment.id }) {
           comments.remove(at: index)
           print("Comment deleted: \(comment.content)")
       }
   }
}

