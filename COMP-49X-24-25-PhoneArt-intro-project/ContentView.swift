//
//  ContentView.swift
//  COMP-49X-24-25-PhoneArt-intro-project
//
//  Created by Aditya Prakash on 11/9/24.
//

import SwiftUI



// This page will be the main page of the application. It will include all of the posts made by users, as well as the ability to create their own post if logged in.
struct ContentView: View {
   @StateObject private var viewModel = PostViewModel()
   @State private var newComment = ""
  
   var body: some View {
       NavigationStack {
           VStack(alignment: .leading, spacing: 16) {
               // The fuction creates the title of the page. Will be in its own Horizontal Stack.
               // This stack will include the sign in/sign out option in a later iteration.
               titleView()
              
               // This fuction creates the Horizontal Stack for the Post Creation Field.
               // It will include the text input field, and the post button.
               postCreationView()
               // This will be the formatting for the border of the Post Creation Horizontal Stack.
               .padding(.horizontal)
               .padding(.vertical, 30)
               .background(
                   RoundedRectangle(cornerRadius: 10)
                   .stroke(Color.gray.opacity(0.3), lineWidth: 4)
               )
               // Add ScrollView for posts. This feature will help accomodate for a large number of posts.
               // A similar feature will be added to the Comment View.
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
       }
   }


   // The UI for the title of the page.
   private func titleView() -> some View {
       HStack {
           Text("Discussions")
               // Formatting for the title.
               .font(.title)
               .bold()
           Spacer()
       }
   }


   // The UI for the Post Creation Field.
   private func postCreationView() -> some View {
       HStack {
           // Text Field. User will be inputting the description of their post here.
           TextField("Share your thoughts here...", text: $newComment)
               // Formatting for the Text Field.
               .padding(.horizontal, 12)
               .padding(.vertical, 7)
               // The overlay will create the border for the textbox.
               .overlay(
                   RoundedRectangle(cornerRadius: 15)
                   .stroke(Color.gray.opacity(0.3), lineWidth: 4)
               )
          
           postButton()
       }
   }
  
   // The UI for the Post Button
   private func postButton() -> some View {
       // Post Button. User will select this once they are ready to post.
       Button("Post") {
           if !newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
               viewModel.addPost(content: newComment)
               newComment = "" // Clear the input field
           }
       }
       // Formatting for the Post Button.
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


// Add a customized view for displaying individual posts
struct PostView: View {
   let post: Post
   @ObservedObject var viewModel: PostViewModel
   // Needed to ensure that the Comment View is displayed when the user clicks on the Comment button.
   @State private var showCommentView = false
  
   var body: some View {
       VStack(alignment: .leading, spacing: 4) {
           // Displaying the timestamp, content, and comment button for each post.
           timestampView()
           contentView()
           HStack {
               commentButton()
               Spacer()
               deleteButton()
           }
       }
       // Navigation Destination to ensure that the Comment View is displayed when the user clicks on the Comment button.
       .navigationDestination(isPresented: $showCommentView) {
           CommentView(post: post)
       }
       // Formatting for the Post View.
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
  
   // The UI for the timestamp of each post.
   private func timestampView() -> some View {
       Text(post.timestamp.formatted())
           .font(.caption)
           .foregroundColor(.gray)
           .frame(maxWidth: .infinity, alignment: .trailing)
   }
  
   // The UI for the content of each post.
   private func contentView() -> some View {
       Text(post.content)
           .padding()
           .frame(maxWidth: .infinity, alignment: .leading)
           .background(Color.gray.opacity(0.1))
           .cornerRadius(10)
   }
  
   // The UI for the Comment button of each post.
   private func commentButton() -> some View {
       Button("Comments") {
           showCommentView = true
       }
       // Formatting for the Comment Button.
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

   // The UI for the Delete button of each post.
   private func deleteButton() -> some View {
       Button("Delete") {
           // To be added by Noah later.
       }
       // Formatting for the Delete Button.
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


// This page will be a new page that will extend from the post comment button.
// It will display the post, as well as the ability to add a comment to the post.
struct CommentView: View {
   let post: Post
   @Environment(\.dismiss) private var dismiss
   @State private var newComment = ""
   @StateObject private var commentViewModel = CommentViewModel()
  
   var body: some View {
       VStack(alignment: .leading, spacing: 16) {
           // The back button will allow the user to return to the main page.
           backButton()
           // The postDisplayView will display the post.
           postDisplayView()
           // The commentsListView will display the list of comments.
           commentsListView()
           Spacer()
       }
       .padding()
       .navigationBarHidden(true)
   }
  
   // The UI for the back button.
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
  
   // The UI for the post display.
   private func postDisplayView() -> some View {
       VStack(alignment: .leading, spacing: 4) {
           // Displaying the timestamp, content, and comment input field for each post.
           timestampView()
           contentView()
           commentInputView()
       }
       // Formatting for the post display.
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
  
   // The UI for the timestamp of each post.
   private func timestampView() -> some View {
       Text(post.timestamp.formatted())
           .font(.caption)
           .foregroundColor(.gray)
           .frame(maxWidth: .infinity, alignment: .trailing)
   }
  
   // The UI for the content of each post.
   private func contentView() -> some View {
       Text(post.content)
           .padding()
           .frame(maxWidth: .infinity, alignment: .leading)
           .background(Color.gray.opacity(0.1))
           .cornerRadius(10)
   }
  
   // The UI for the comment input field.
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
                   commentViewModel.addComment(content: newComment)
                   newComment = ""
               }
           }
           // Formatting for the Comment Button.
           .bold()
           .padding(.horizontal, 20)
           .padding(.vertical, 8)
           .background(Color(red: 0.0, green: 0.0, blue: 0.5))
           .foregroundColor(.white)
           .cornerRadius(15)
       }
       .padding(.top, 8)
   }
   
   // The UI for displaying the list of comments.
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
                           .frame(maxWidth: .infinity * 0.9, alignment: .leading)
                           .background(Color.gray.opacity(0.1))
                           .cornerRadius(10)
                       HStack {
                           Spacer()
                           Button(action: {
                               // Delete functionality will be added by Noah later
                           }) {
                               Text("Delete")
                                   .foregroundColor(.red)
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
