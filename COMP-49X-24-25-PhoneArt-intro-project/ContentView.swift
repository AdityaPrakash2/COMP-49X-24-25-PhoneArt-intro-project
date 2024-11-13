//
//  ContentView.swift
//  COMP-49X-24-25-PhoneArt-intro-project
//
//  Created by Aditya Prakash on 11/9/24.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = PostViewModel()
    @State private var newComment = ""
    
    var body: some View {
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
            
            // Add ScrollView for posts
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.posts) { post in
                        PostView(post: post)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
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
}

// Add a new view for displaying individual posts
struct PostView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.content)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Text(post.timestamp.formatted())
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}


#Preview {
    ContentView()
}
