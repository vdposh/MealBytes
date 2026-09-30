//
//  ProfileViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
    @Published var email: String?
    @Published var alertContent: AlertContentProfile?
    @Published var appError: AppError?
    @Published var showAlert: Bool = false
    @Published var isDeletingAccount: Bool = false
    
    @ObservedObject var loginViewModel: LoginViewModel
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    let mainViewModel: MainViewModelProtocol
    
    init(
        loginViewModel: LoginViewModel,
        mainViewModel: MainViewModelProtocol
    ) {
        self.loginViewModel = loginViewModel
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Load Profile Data
    func loadProfileData() async {
        guard let user = Auth.auth().currentUser else {
            await MainActor.run {
                email = nil
                signOut()
            }
            
            return
        }
        
        await MainActor.run {
            email = user.email
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try firebaseAuth.signOutAuth()
            
            Task {
                do {
                    try await firestore.deleteLoginDataFirestore()
                } catch {
                    appError = .network
                }
            }
            
            resetProfileState()
        } catch {
            appError = .decoding
        }
    }
    
    // MARK: - Delete Account
    private func deleteAccount() async {
        await MainActor.run {
            isDeletingAccount = true
        }
        
        do {
            try await firebaseAuth.deleteAccountAuth()
            
            do {
                try await firestore.deleteLoginDataFirestore()
            } catch {
                await MainActor.run {
                    appError = .network
                }
            }
            
            resetProfileState()
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
        
        await MainActor.run {
            isDeletingAccount = false
        }
    }
    
    // MARK: - Alert
    func prepareAlert(for type: AlertTypeProfileView) {
        alertContent = AlertContentProfile(type: type)
        showAlert = true
    }
    
    func handleProfileAlertAction() async {
        guard let alertType = alertContent?.type else { return }
        
        switch alertType {
        case .signOut:
            signOut()
            
        case .deleteAccount:
            await deleteAccount()
        }
    }
    
    // MARK: - Reset State
    private func resetProfileState() {
        alertContent = nil
        appError = nil
        
        showAlert = false
        isDeletingAccount = false
        
        loginViewModel.resetLoginState()
    }
    
    // MARK: - UI Helper
    var alertTitle: String {
        alertContent?.title ?? "Alert"
    }
    
    var alertMessage: String {
        alertContent?.message ?? ""
    }
    
    var destructiveTitle: String {
        alertContent?.destructiveTitle ?? "Confirm"
    }
    
    var isLoading: Bool {
        isDeletingAccount
    }
}

#Preview {
    PreviewContentView.contentView
}
