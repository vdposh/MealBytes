//
//  ProfileViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI
import FirebaseAuth
import OSLog

final class ProfileViewModel: ObservableObject {
    @Published var email: String?
    @Published var deleteConfirmationText: String = ""
    @Published var alertContent: AlertContentProfile?
    @Published var energyUnit: EnergyUnit = .kcal
    @Published var showAlert: Bool = false
    @Published var displayGoals: Bool = true
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
            displayGoals = mainViewModel.displayGoals
            energyUnit = mainViewModel.energyUnit
        }
    }
    
    // MARK: - Goals
    func setDisplayGoals(_ display: Bool) async {
        await MainActor.run {
            displayGoals = display
        }
        
        await mainViewModel.setDisplayGoals(display)
    }
    
    // MARK: - Energy Unit
    func setEnergyUnit(_ unit: EnergyUnit) async {
        await MainActor.run {
            energyUnit = unit
        }
        
        await mainViewModel.setEnergyUnit(unit)
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try firebaseAuth.signOutAuth()
            
            Task {
                do {
                    try await firestore.deleteLoginDataFirestore()
                } catch {
                    Logger.profile.error("deleteLoginData (signOut) failed: \(error.localizedDescription)")
                }
            }
            
            resetProfileState()
        } catch {
            Logger.profile.error("signOutAuth failed: \(error.localizedDescription)")
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
                Logger.profile.error("deleteLoginData (deleteAccount) failed: \(error.localizedDescription)")
            }
            
            resetProfileState()
        } catch {
            Logger.profile.error("deleteAccountAuth failed: \(error.localizedDescription)")
        }
        
        await MainActor.run {
            isDeletingAccount = false
        }
    }
    
    // MARK: - Alert
    func prepareAlert(for type: AlertTypeProfileView) {
        deleteConfirmationText = ""
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
        
        deleteConfirmationText = ""
        
        showAlert = false
        isDeletingAccount = false
        
        loginViewModel.resetLoginState()
    }
    
    // MARK: - UI Helper
    var isLoggedIn: Bool {
        !(email ?? "").isEmpty
    }
    
    var alertTitle: String {
        alertContent?.title ?? "Alert"
    }
    
    var alertMessage: String {
        alertContent?.message ?? ""
    }
    
    var destructiveTitle: String {
        alertContent?.destructiveTitle ?? "Confirm"
    }
    
    var isDeleteConfirmed: Bool {
        deleteConfirmationText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() == "delete"
    }
}

#Preview {
    PreviewContentView.contentView
}
