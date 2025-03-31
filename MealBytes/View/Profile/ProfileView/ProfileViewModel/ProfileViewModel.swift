//
//  ProfileViewModel.swift
//  MealBytes
//
//  Created by Porshe on 30/03/2025.
//

import SwiftUI
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
    @Published var email: String?
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var destructiveButtonTitle: String = ""
    @Published var alertType: AlertType?
    @Published var appError: AppError?
    @Published var showAlert: Bool = false
    @Published var isDataLoaded: Bool = false
    
    var bindingForShouldDisplayRdi: Binding<Bool> {
        Binding(
            get: { self.mainViewModel.shouldDisplayRdi },
            set: { newValue in
                self.mainViewModel.shouldDisplayRdi = newValue
                Task {
                    await self.mainViewModel.saveDisplayRdiMainView(newValue)
                }
            }
        )
    }
    
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var mainViewModel: MainViewModel
    private let firestoreAuth: FirestoreAuthProtocol = FirestoreAuth()
    
    init(loginViewModel: LoginViewModel,
         mainViewModel: MainViewModel) {
        self.loginViewModel = loginViewModel
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try firestoreAuth.signOutFirebase()
            Task {
                await MainActor.run {
                    loginViewModel.isLoggedIn = false
                }
            }
        } catch {
            appError = .decoding
        }
    }
    
    // MARK: - Delete Account
    func deleteAccount() async {
        do {
            try await firestoreAuth.deleteAccountFirebase()
            Task {
                await MainActor.run {
                    loginViewModel.isLoggedIn = false
                }
            }
        } catch {
            Task {
                await MainActor.run {
                    appError = .decoding
                }
            }
        }
    }
    
    // MARK: - Fetch Current User Email
    func fetchCurrentUserEmail() async {
        guard let user = Auth.auth().currentUser else {
            Task {
                await MainActor.run {
                    email = nil
                }
            }
            return
        }
        Task {
            await MainActor.run {
                email = user.email
            }
        }
    }
    
    // MARK: - Load Data
    func loadProfileData() async {
        await mainViewModel.loadDisplayRdiMainView()
        await fetchCurrentUserEmail()
        Task {
            await MainActor.run {
                isDataLoaded = true
            }
        }
    }
    
    // MARK: - Alert
    func prepareAlert(for type: AlertType) {
        Task {
            await MainActor.run {
                alertType = type
                showAlert = true
                
                switch type {
                case .signOut:
                    alertTitle = "Sign out"
                    alertMessage = "You will need to sign in again to access your account."
                    destructiveButtonTitle = "Sign Out"
                case .deleteAccount:
                    alertTitle = "Are you sure you want to delete your profile?"
                    alertMessage = "All your data, preferences, and account details will be permanently erased. This action cannot be undone."
                    destructiveButtonTitle = "Delete"
                }
            }
        }
    }
    
    func handleAlertAction() {
        switch alertType {
        case .signOut:
            signOut()
        case .deleteAccount:
            Task {
                await deleteAccount()
            }
        case .none:
            break
        }
    }
    
    enum AlertType {
        case signOut
        case deleteAccount
    }
}
