//
//  MealBytesApp.swift
//  MealBytes
//
//  Created by Porshe on 06/03/2025.
//

import SwiftUI
import FirebaseCore

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
        let firestoreManager = FirestoreManager()
        let mainViewModel = MainViewModel(firestoreManager: firestoreManager)
        let customRdiViewModel = CustomRdiViewModel(
            firestoreManager: firestoreManager,
            mainViewModel: mainViewModel
        )
        let rdiViewModel = RdiViewModel(
            firestoreManager: firestoreManager,
            mainViewModel: mainViewModel
        )
        let goalsViewModel = GoalsViewModel(
            customRdiViewModel: customRdiViewModel,
            rdiViewModel: rdiViewModel
        )
        
        WindowGroup {
            TabBarView(
                mainViewModel: mainViewModel,
                goalsViewModel: goalsViewModel
            )
            .accentColor(.customGreen)
        }
    }
}
