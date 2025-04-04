//
//  MealBytesApp.swift
//  MealBytes
//
//  Created by Porshe on 06/03/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [
                        UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
                            FirebaseApp.configure()
                            return true
                        }
}

@main
struct MealBytesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(.customGreen)
        }
    }
}
