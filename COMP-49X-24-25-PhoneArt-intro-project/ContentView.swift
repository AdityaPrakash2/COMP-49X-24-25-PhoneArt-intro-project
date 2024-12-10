import SwiftUI
import FirebaseFirestore


// Login page for the app. Users will need to sign in to access the main content view.
struct ContentView: View {
   @State private var isAuthenticated = false
   @State private var username = ""
   @State private var password = ""
  
   var body: some View {
       if isAuthenticated {
           MainContentView(isAuthenticated: $isAuthenticated)
       } else {
           VStack(spacing: 20) {
               Text("Welcome!")
                   .font(.title)
                   .bold()
              
               TextField("Username", text: $username)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .padding(.horizontal, 40)
              
               SecureField("Password", text: $password)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .padding(.horizontal, 40)
              
               Button("Sign In") {
                   // Add your authentication logic here
                   isAuthenticated = true  // For now, just sets to true
               }
               .frame(width: 200)
               .padding()
               .background(Color.blue)
               .foregroundColor(.white)
               .cornerRadius(10)
           }
       }
   }
}

// Once the user has signed in, they will be redirected to the main content view, where they can view posts, add new posts, and view/add comments to existing posts.
struct MainContentView: View {
   @StateObject private var viewModel = PostViewModel()
   @State private var newComment = ""
   @Binding var isAuthenticated: Bool
  
   var body: some View {
       NavigationStack {
           VStack(alignment: .leading, spacing: 16) {
               // Title view for Discussions
               titleView()
               // Post creation view
               postCreationView()
               .padding(.horizontal)
               .padding(.vertical, 30)
               .background(
                   RoundedRectangle(cornerRadius: 10)
                   .stroke(Color.gray.opacity(0.3), lineWidth: 4)
               )
               // List of posts
               ScrollView {
                   LazyVStack(alignment: .leading, spacing: 12) {
                       ForEach(viewModel.posts) { post in
                           PostView(post: post, viewModel: viewModel)
                       }
                   }
               }
               Spacer()
           }
           .padding()
           .onAppear {
               viewModel.fetchPosts() // Fetch posts when the view appears
           }
           .toolbar {
               ToolbarItem(placement: .navigationBarTrailing) {
                   Button("Sign Out") {
                       isAuthenticated = false
                   }
                   .foregroundColor(.red)
               }
           }
       }
   }
   // UI for the title of the page
   private func titleView() -> some View {
       HStack {
           Text("Discussions")
               .font(.title)
               .bold()
           Spacer()
       }
   }
   // UI for the Post Creation Field
   private func postCreationView() -> some View {
       HStack {
           // Text Field for creating a new post
           TextField("Share your thoughts here...", text: $newComment)
               .padding(.horizontal, 12)
               .padding(.vertical, 7)
               .overlay(
                   RoundedRectangle(cornerRadius: 15)
                   .stroke(Color.gray.opacity(0.3), lineWidth: 4)
               )
           postButton()
       }
   }
   // UI for the Post Button
   private func postButton() -> some View {
       Button("Post") {
           if !newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
               viewModel.addPost(content: newComment) // Add post to Firestore
               newComment = "" // Clear the input field
           }
       }
       .padding(.horizontal, 20)
       .padding(.vertical, 8)
       .background(Color(red: 0.5, green: 0.0, blue: 0.5))
       .foregroundColor(.white)
       .bold()
       .cornerRadius(15)
       .overlay(
           RoundedRectangle(cornerRadius: 15)
           .stroke(Color(red: 0.4, green: 0.0, blue: 0.4), lineWidth: 4)
       )
   }
}

// View for displaying individual posts
struct PostView: View {
  let post: Post
  @ObservedObject var viewModel: PostViewModel
  @State private var showCommentView = false
  var body: some View {
      VStack(alignment: .leading, spacing: 4) {
          timestampView()
          contentView()
          HStack {
              commentButton()
              Spacer()
              deleteButton()
          }
      }
      .navigationDestination(isPresented: $showCommentView) {
          CommentView(post: post) // Show CommentView when Comments button is clicked
      }
      .padding(.horizontal)
      .padding(.top, 15)
      .padding(.bottom, 20)
      .background(
          RoundedRectangle(cornerRadius: 10)
              .stroke(Color.gray.opacity(0.3), lineWidth: 4)
      )
      .padding(.horizontal)
      .padding(.vertical, 8)
  }
  private func timestampView() -> some View {
      Text(post.timestamp.formatted())
          .font(.caption)
          .foregroundColor(.gray)
          .frame(maxWidth: .infinity, alignment: .trailing)
  }
  private func contentView() -> some View {
      Text(post.content)
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color.gray.opacity(0.1))
          .cornerRadius(10)
  }
  private func commentButton() -> some View {
      Button("Comments") {
          showCommentView = true
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 8)
      .background(Color(red: 0.0, green: 0.0, blue: 0.5))
      .foregroundColor(.white)
      .bold()
      .cornerRadius(15)
      .overlay(
          RoundedRectangle(cornerRadius: 15)
              .stroke(Color(red: 0.0, green: 0.0, blue: 0.4), lineWidth: 4)
      )
      .padding(.top, 8)
  }
   private func deleteButton() -> some View {
       Button("Delete") {
           viewModel.deletePost(post: post) // Pass the entire post
       }
       .padding(.horizontal, 20)
       .padding(.vertical, 8)
       .background(Color(red: 0.8, green: 0.0, blue: 0.0))
       .foregroundColor(.white)
       .bold()
       .cornerRadius(15)
       .overlay(
           RoundedRectangle(cornerRadius: 15)
               .stroke(Color(red: 0.6, green: 0.0, blue: 0.0), lineWidth: 4)
       )
       .padding(.top, 8)
   }
}
// View for displaying comments on a specific post
struct CommentView: View {
  let post: Post
  @Environment(\.dismiss) private var dismiss
  @State private var newComment = ""
  @StateObject private var commentViewModel = CommentViewModel()
  var body: some View {
      VStack(alignment: .leading, spacing: 16) {
          backButton()
          postDisplayView()
          commentsListView()
          Spacer()
      }
      .padding()
      .navigationBarHidden(true)
      .onAppear {
          commentViewModel.fetchComments(forPostId: post.id.uuidString)
      }
  }
  private func backButton() -> some View {
      Button(action: {
          dismiss()
      }) {
          HStack {
              Image(systemName: "chevron.left")
              Text("Back")
          }
      }
      .padding(.bottom)
  }
  private func postDisplayView() -> some View {
      VStack(alignment: .leading, spacing: 4) {
          timestampView()
          contentView()
          commentInputView()
      }
      .padding(.horizontal)
      .padding(.top, 15)
      .padding(.bottom, 20)
      .background(
          RoundedRectangle(cornerRadius: 10)
              .stroke(Color.gray.opacity(0.3), lineWidth: 4)
      )
      .padding(.horizontal)
      .padding(.vertical, 8)
  }
  private func timestampView() -> some View {
      Text(post.timestamp.formatted())
          .font(.caption)
          .foregroundColor(.gray)
          .frame(maxWidth: .infinity, alignment: .trailing)
  }
  private func contentView() -> some View {
      Text(post.content)
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color.gray.opacity(0.1))
          .cornerRadius(10)
  }
  private func commentInputView() -> some View {
      HStack {
          TextField("Add Comment...", text: $newComment)
              .padding(.horizontal, 12)
              .padding(.vertical, 7)
              .overlay(
                  RoundedRectangle(cornerRadius: 15)
                      .stroke(Color.gray.opacity(0.3), lineWidth: 4)
              )
          Button("Comment") {
              if !newComment.isEmpty {
                  commentViewModel.addComment(postId: post.id.uuidString, content: newComment)
                  newComment = ""
              }
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 8)
          .background(Color(red: 0.0, green: 0.0, blue: 0.5))
          .foregroundColor(.white)
          .cornerRadius(15)
      }
      .padding(.top, 8)
  }
  private func commentsListView() -> some View {
      ScrollView {
          LazyVStack(alignment: .leading, spacing: 12) {
              ForEach(commentViewModel.comments) { comment in
                  VStack(alignment: .leading, spacing: 4) {
                      Text(comment.timestamp.formatted())
                          .font(.caption)
                          .foregroundColor(.gray)
                          .frame(maxWidth: .infinity, alignment: .trailing)
                      Text(comment.content)
                          .padding()
                          .background(Color.gray.opacity(0.1))
                          .cornerRadius(10)
                      HStack {
                          Spacer()
                          Text("Delete")
                              .foregroundColor(.red)
                              .onTapGesture {
                                  commentViewModel.deleteComment(comment: comment, postId: post.id.uuidString)
                              }
                      }
                  }
                  .padding(.horizontal, 25)
                  .padding(.vertical, 8)
              }
          }
      }
  }
}
#Preview {
   ContentView()
}





