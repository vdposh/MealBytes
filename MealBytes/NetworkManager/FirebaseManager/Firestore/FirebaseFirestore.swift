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
    func loadLoginDataFirestore() async throws -> (email: String,
                                                   isLoggedIn: Bool)
    func loadCustomRdiFirestore() async throws -> CustomRdiData
    func loadRdiFirestore() async throws -> RdiData
    func loadMainRdiFirestore() async throws -> MainRdiData
    func loadDisplayRdiFirestore() async throws -> Bool
    func addMealItemFirestore(_ mealItem: MealItem) async throws
    func addBookmarkFirestore(_ foods: [Food],
                              for mealType: MealType) async throws
    func saveLoginDataFirestore(email: String, isLoggedIn: Bool) async throws
    func saveCustomRdiFirestore(_ customGoalsData: CustomRdiData) async throws
    func saveRdiFirestore(_ rdiData: RdiData) async throws
    func saveMainRdiFirestore(_ data: MainRdiData) async throws
    func saveDisplayRdiFirestore(_ displayRdi: Bool) async throws
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
        let snapshot = try await firestore.collection("Users")
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
        let documentReference = firestore.collection("Users")
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
        let documentReference = firestore.collection("Users")
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
        let documentReference = firestore.collection("Users")
            .document(uid)
            .collection("MainView")
            .document(mealItem.id.uuidString)
        try await documentReference.delete()
    }
    
    // MARK: - Load bookmarks
    func loadBookmarksFirestore(for mealType: MealType) async throws -> [Food] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let snapshot = try await firestore.collection("Users")
            .document(uid)
            .collection("SearchView")
            .document("Bookmarks")
            .getDocument()
        
        guard let data = snapshot.data(),
              let foodsArray = data[mealType.rawValue.lowercased()] as?
                [[String: Any]] else {
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
        
        try await firestore.collection("Users")
            .document(uid)
            .collection("SearchView")
            .document("Bookmarks")
            .setData([mealType.rawValue.lowercased(): encodedFoods],
                     merge: true)
    }
    
    // MARK: - Load customRDI Data
    func loadCustomRdiFirestore() async throws -> CustomRdiData {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("CustomRdiView")
        return try await documentReference.getDocument(as: CustomRdiData.self)
    }
    
    // MARK: - Save customRDI Data
    func saveCustomRdiFirestore(_ customGoalsData: CustomRdiData) throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("CustomRdiView")
        try documentReference.setData(from: customGoalsData)
    }
    
    // MARK: - Load RDI Data
    func loadRdiFirestore() async throws -> RdiData {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("Users")
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
        let documentReference = firestore.collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("RdiView")
        try documentReference.setData(from: rdiData)
    }
    
    // MARK: - Load RDI String
    func loadMainRdiFirestore() async throws -> MainRdiData {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("RDI")
        let snapshot = try await documentReference.getDocument()
        return try snapshot.data(as: MainRdiData.self)
    }
    
    // MARK: - Save RDI String
    func saveMainRdiFirestore(_ data: MainRdiData) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("RDI")
        try documentReference.setData(from: data)
    }
    
    // MARK: - Load Display RDI
    func loadDisplayRdiFirestore() async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("DisplayRDI")
        let snapshot = try await documentReference.getDocument()
        guard let data = snapshot.data(),
              let displayRdi = data["displayRdi"] as? Bool else {
            throw AppError.decoding
        }
        return displayRdi
    }
    
    // MARK: - Save Display RDI
    func saveDisplayRdiFirestore(_ displayRdi: Bool) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("DisplayRDI")
        try await documentReference.setData(
            ["displayRdi": displayRdi]
        )
    }
    
    // MARK: - Current User
    func loadLoginDataFirestore() async throws -> (email: String,
                                                   isLoggedIn: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AuthError.userNotFound
        }
        
        let snapshot = try await firestore.collection("Users")
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
    
    func saveLoginDataFirestore(email: String,
                                isLoggedIn: Bool) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let data: [String: Any] = [
            "email": email,
            "isLoggedIn": isLoggedIn
        ]
        try await firestore.collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("LoginInfo")
            .setData(data, merge: true)
    }
    
    func deleteLoginDataFirestore() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentReference = firestore.collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("LoginInfo")
        try await documentReference.delete()
    }
}
