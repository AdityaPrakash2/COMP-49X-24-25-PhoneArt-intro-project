import Foundation
import FirebaseFirestore
public struct Comment: Identifiable {
   public let id: UUID
   public let documentID: String // Added to store Firestore document ID
   public let content: String
   public let timestamp: Date
   public init(id: UUID = UUID(), documentID: String, content: String, timestamp: Date) {
       self.id = id
       self.documentID = documentID
       self.content = content
       self.timestamp = timestamp
   }
}
public class CommentViewModel: ObservableObject {
   @Published public var comments: [Comment] = []
   @Published public var currentPostId: String?
   private let db = Firestore.firestore()
   // Fetch comments for a specific post
   public func fetchComments(forPostId postId: String) {
       self.currentPostId = postId
       db.collection("comments").whereField("postId", isEqualTo: postId)
           .order(by: "timestamp", descending: true)
           .getDocuments { snapshot, error in
               if let error = error {
                   print("Error fetching comments: \(error.localizedDescription)")
                   return
               }
               self.comments = snapshot?.documents.compactMap { document -> Comment? in
                   let data = document.data()
                   guard let content = data["content"] as? String,
                         let timestamp = data["timestamp"] as? Timestamp else {
                       return nil
                   }
                   return Comment(id: UUID(), documentID: document.documentID, content: content, timestamp: timestamp.dateValue())
               } ?? []
           }
   }
   // Function to add a new comment to Firestore
   public func addComment(postId: String, content: String) {
       let commentRef = db.collection("comments").document()
       let commentData: [String: Any] = [
           "id": commentRef.documentID,
           "postId": postId,
           "content": content,
           "timestamp": Date()
       ]
       commentRef.setData(commentData) { error in
           if let error = error {
               print("Error adding comment: \(error.localizedDescription)")
           } else {
               print("New comment added: \(content)")
               // Refresh comments after adding a new one
               self.fetchComments(forPostId: postId)
           }
       }
   }
  
   // Function to delete a comment from Firestore
   public func deleteComment(comment: Comment, postId: String) {
       db.collection("comments").document(comment.documentID).delete { error in
           if let error = error {
               print("Error deleting comment: \(error.localizedDescription)")
           } else {
               print("Comment deleted successfully.")
               self.fetchComments(forPostId: postId) // Refresh the comments after deletion
           }
       }
   }
   // Add a refresh function that can be called when returning to the view
   public func refreshCurrentComments() {
       if let postId = currentPostId {
           fetchComments(forPostId: postId)
       }
   }
}

