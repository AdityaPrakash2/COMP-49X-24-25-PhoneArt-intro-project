//
//  COMP_49X_24_25_PhoneArt_intro_projectApp.swift
//  COMP-49X-24-25-PhoneArt-intro-project
//
//  Created by Aditya Prakash on 11/9/24.
//

import SwiftUI
import Firebase

@main
struct COMP_49X_24_25_PhoneArt_intro_projectApp: App {
    
    init() {
            FirebaseApp.configure() 
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
