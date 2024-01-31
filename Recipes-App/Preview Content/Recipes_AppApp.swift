//
//  Recipes_AppApp.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 12/01/24.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin

@main
struct Recipes_AppApp: App {
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
    
    init() {
       configureAmplify()
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Amplify configured with Auth and Storage plugins")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
    }

}
