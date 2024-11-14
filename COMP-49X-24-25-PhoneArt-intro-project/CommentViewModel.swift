import Foundation
import FirebaseFirestore
public struct Comment: Identifiable {
    public let id: UUID
    public let content: String
    public let timestamp: Date
    public init(id: UUID = UUID(), content: String, timestamp: Date) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
    }
}
public class CommentViewModel: ObservableObject {
    @Published public var comments: [Comment] = []
    private let db = Firestore.firestore()
    // Fetch comments for a specific post
    public func fetchComments(forPostId postId: String) {
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
                    return Comment(id: UUID(), content: content, timestamp: timestamp.dateValue())
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
}

