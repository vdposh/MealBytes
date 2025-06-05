//
//  MealBytesApp.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06/03/2025.
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
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var systemColorScheme
    
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                loginViewModel: loginViewModel,
                mainViewModel: mainViewModel
            )
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.appliedColorScheme)
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    Task {
                        try await TokenManager.shared.fetchToken()
                        await mainViewModel.loadMainData()
                        await loginViewModel.loadLoginData()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}
