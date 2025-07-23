//
//  FirebaseFirestore.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 21/03/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

protocol FirebaseFirestoreProtocol {
    func loadMealItemsFirestore() async throws -> [MealItem]
    func loadBookmarksFirestore(for mealType: MealType) async throws -> [Food]
    func loadLoginDataFirestore() async throws -> (
        email: String,
        isLoggedIn: Bool
    )
    func loadDailyIntakeFirestore() async throws -> DailyIntake
    func loadRdiFirestore() async throws -> RdiData
    func loadCurrentIntakeFirestore() async throws -> CurrentIntake
    func loadDisplayIntakeFirestore() async throws -> Bool
    func addMealItemFirestore(_ mealItem: MealItem) async throws
    func addBookmarkFirestore(
        _ foods: [Food],
        for mealType: MealType
    ) async throws
    func saveLoginDataFirestore(email: String, isLoggedIn: Bool) async throws
    func saveDailyIntakeFirestore(_ DailyIntakeData: DailyIntake) async throws
    func saveRdiFirestore(_ rdiData: RdiData) async throws
    func saveCurrentIntakeFirestore(_ data: CurrentIntake) async throws
    func saveDisplayIntakeFirestore(_ displayIntake: Bool) async throws
    func updateMealItemFirestore(_ mealItem: MealItem) async throws
    func deleteMealItemFirestore(_ mealItem: MealItem) async throws
    func deleteLoginDataFirestore() async throws
}

final class FirebaseFirestore: FirebaseFirestoreProtocol {
    private lazy var firestore = Firestore.firestore()
    
    // MARK: - Fetch Data
    func loadMealItemsFirestore() async throws -> [MealItem] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("MainView")
            .order(by: "createdAt")
            .getDocuments()
        
        let mealItems = try snapshot.documents.compactMap { document in
            try document.data(as: MealItem.self)
        }
        
        return mealItems
    }
    
    // MARK: - Save Data
    func addMealItemFirestore(_ mealItem: MealItem) throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("MainView")
            .document(mealItem.id.uuidString)
        try documentReference.setData(from: mealItem)
    }
    
    // MARK: - Update Data
    func updateMealItemFirestore(_ mealItem: MealItem) throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("MainView")
            .document(mealItem.id.uuidString)
        try documentReference.setData(from: mealItem, merge: true)
    }
    
    // MARK: - Delete Data
    func deleteMealItemFirestore(_ mealItem: MealItem) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("MainView")
            .document(mealItem.id.uuidString)
        try await documentReference.delete()
    }
    
    // MARK: - Load bookmarks
    func loadBookmarksFirestore(
        for mealType: MealType
    ) async throws -> [Food] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("SearchView")
            .document(mealType.rawValue.lowercased())
            .getDocument()
        
        guard let data = snapshot.data(),
              let foodsArray = data["items"] as? [[String: Any]] else {
            return []
        }
        
        return foodsArray.compactMap { foodData in
            Food(
                searchFoodId: foodData["food_id"] as? Int ?? 0,
                searchFoodName: foodData["food_name"] as? String ?? "",
                searchFoodDescription: foodData["food_description"] as?
                String ?? ""
            )
        }
    }
    
    // MARK: - Add bookmarks
    func addBookmarkFirestore(_ foods: [Food],
                              for mealType: MealType) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let encodedFoods = try foods.map { try Firestore.Encoder().encode($0) }
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("SearchView")
            .document(mealType.rawValue.lowercased())
        
        try await documentReference.setData(
            ["items": encodedFoods],
            merge: true
        )
    }
    
    // MARK: - Load DailyIntake Data
    func loadDailyIntakeFirestore() async throws -> DailyIntake {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("DailyIntakeView")
        return try await documentReference.getDocument(as: DailyIntake.self)
    }
    
    // MARK: - Save DailyIntake Data
    func saveDailyIntakeFirestore(_ DailyIntakeData: DailyIntake) throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("DailyIntakeView")
        try documentReference.setData(from: DailyIntakeData)
    }
    
    // MARK: - Load RDI Data
    func loadRdiFirestore() async throws -> RdiData {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("RdiView")
        return try await documentReference.getDocument(as: RdiData.self)
    }
    
    // MARK: - Save RDI Data
    func saveRdiFirestore(_ rdiData: RdiData) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("RdiView")
        try documentReference.setData(from: rdiData)
    }
    
    // MARK: - Load Intake
    func loadCurrentIntakeFirestore() async throws -> CurrentIntake {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("CurrentIntake")
        let snapshot = try await documentReference.getDocument()
        return try snapshot.data(as: CurrentIntake.self)
    }
    
    // MARK: - Save Intake
    func saveCurrentIntakeFirestore(_ data: CurrentIntake) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("CurrentIntake")
        try documentReference.setData(from: data)
    }
    
    // MARK: - Load Display Intake
    func loadDisplayIntakeFirestore() async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("DisplayIntake")
        let snapshot = try await documentReference.getDocument()
        guard let data = snapshot.data(),
              let displayIntake = data["displayIntake"] as? Bool else {
            throw AppError.decoding
        }
        return displayIntake
    }
    
    // MARK: - Save Display Intake
    func saveDisplayIntakeFirestore(_ displayIntake: Bool) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("DisplayIntake")
        try await documentReference.setData(
            ["displayIntake": displayIntake]
        )
    }
    
    // MARK: - Current User
    func loadLoginDataFirestore() async throws -> (
        email: String,
        isLoggedIn: Bool
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AuthError.userNotFound
        }
        
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("LoginInfo")
            .getDocument()
        
        guard let data = snapshot.data(),
              let email = data["email"] as? String,
              let isLoggedIn = data["isLoggedIn"] as? Bool else {
            throw AppError.decoding
        }
        
        return (email, isLoggedIn)
    }
    
    func saveLoginDataFirestore(
        email: String,
        isLoggedIn: Bool
    ) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let data: [String: Any] = [
            "email": email,
            "isLoggedIn": isLoggedIn
        ]
        try await firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("LoginInfo")
            .setData(data, merge: true)
    }
    
    func deleteLoginDataFirestore() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("LoginInfo")
        try await documentReference.delete()
    }
}

#Preview {
    PreviewContentView.contentView
}
