//
//  FirebaseFirestore.swift
//  MealBytes
//
//  Created by Porshe on 21/03/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

protocol FirebaseFirestoreProtocol {
    func loadMealItemsFirestore() async throws -> [MealItem]
    func loadBookmarksFirestore() async throws -> [Food]
    func loadLoginDataFirestore() async throws -> (email: String,
                                                   isLoggedIn: Bool)
    func loadCustomRdiFirestore() async throws -> CustomRdiData
    func loadRdiFirestore() async throws -> RdiData
    func loadMainRdiFirestore() async throws -> String
    func loadDisplayRdiFirestore() async throws -> Bool
    func addMealItemFirestore(_ mealItem: MealItem) async throws
    func addBookmarkFirestore(_ foods: [Food]) async throws
    func saveLoginDataFirestore(email: String, isLoggedIn: Bool) async throws
    func saveCustomRdiFirestore(_ customGoalsData: CustomRdiData) async throws
    func saveRdiFirestore(_ rdiData: RdiData) async throws
    func saveMainRdiFirestore(_ rdi: String) async throws
    func saveDisplayRdiFirestore(_ shouldDisplayRdi: Bool) async throws
    func updateMealItemFirestore(_ mealItem: MealItem) async throws
    func deleteMealItemFirestore(_ mealItem: MealItem) async throws
    func deleteLoginDataFirestore() async throws
}

final class FirebaseFirestore: FirebaseFirestoreProtocol {
    private let firestore: Firestore = Firestore.firestore()
    
    // MARK: - Fetch Data
    func loadMealItemsFirestore() async throws -> [MealItem] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let snapshot = try await firestore.collection("users")
            .document(uid)
            .collection("meals")
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
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("meals")
            .document(mealItem.id.uuidString)
        try documentReference.setData(from: mealItem)
    }
    
    // MARK: - Update Data
    func updateMealItemFirestore(_ mealItem: MealItem) throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("meals")
            .document(mealItem.id.uuidString)
        try documentReference.setData(from: mealItem, merge: true)
    }
    
    // MARK: - Delete Data
    func deleteMealItemFirestore(_ mealItem: MealItem) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("meals")
            .document(mealItem.id.uuidString)
        try await documentReference.delete()
    }
    
    // MARK: - Load bookmarks
    func loadBookmarksFirestore() async throws -> [Food] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let snapshot = try await firestore.collection("users")
            .document(uid)
            .collection("favoriteFoods")
            .document("favorites")
            .getDocument()
        
        guard let data = snapshot.data(),
              let foodsArray = data["foods"] as? [[String: Any]] else {
            return []
        }
        
        return foodsArray.compactMap { foodData in
            Food(
                searchFoodId: foodData["food_id"] as? Int ?? 0,
                searchFoodName: foodData["food_name"] as? String ?? "",
                searchFoodDescription: foodData[
                    "food_description"] as? String ?? ""
            )
        }
    }
    
    // MARK: - Add bookmarks
    func addBookmarkFirestore(_ foods: [Food]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let data = try foods.map { food in
            try Firestore.Encoder().encode(food)
        }
        try await firestore.collection("users")
            .document(uid)
            .collection("favoriteFoods")
            .document("favorites")
            .setData(["foods": data])
    }
    
    // MARK: - Load customRDI Data
    func loadCustomRdiFirestore() async throws -> CustomRdiData {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("userCustomRdiGoals")
            .document("currentCustomGoals")
        return try await documentReference.getDocument(as: CustomRdiData.self)
    }
    
    // MARK: - Save customRDI Data
    func saveCustomRdiFirestore(_ customGoalsData: CustomRdiData) throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("userCustomRdiGoals")
            .document("currentCustomGoals")
        try documentReference.setData(from: customGoalsData)
    }
    
    // MARK: - Load RDI Data
    func loadRdiFirestore() async throws -> RdiData {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("userRdiGoals")
            .document("currentRdiGoals")
        return try await documentReference.getDocument(as: RdiData.self)
    }
    
    // MARK: - Save RDI Data
    func saveRdiFirestore(_ rdiData: RdiData) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("userRdiGoals")
            .document("currentRdiGoals")
        try documentReference.setData(from: rdiData)
    }
    
    // MARK: - Load RDI String
    func loadMainRdiFirestore() async throws -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("rdi")
            .document("myRdi")
        let snapshot = try await documentReference.getDocument()
        guard let data = snapshot.data(),
              let rdi = data["rdi"] as? String else {
            return ""
        }
        return rdi
    }
    
    // MARK: - Save RDI String
    func saveMainRdiFirestore(_ rdi: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("rdi")
            .document("myRdi")
        try await documentReference.setData(["rdi": rdi])
    }
    
    // MARK: - Load Display RDI
    func loadDisplayRdiFirestore() async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("settings")
            .document("displayRdi")
        let snapshot = try await documentReference.getDocument()
        guard let data = snapshot.data(),
              let shouldDisplayRdi = data["shouldDisplayRdi"] as? Bool else {
            throw AppError.decoding
        }
        return shouldDisplayRdi
    }
    
    // MARK: - Save Display RDI
    func saveDisplayRdiFirestore(_ shouldDisplayRdi: Bool) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("settings")
            .document("displayRdi")
        try await documentReference.setData(
            ["shouldDisplayRdi": shouldDisplayRdi]
        )
    }
    
    // MARK: - Current User
    func loadLoginDataFirestore() async throws -> (email: String,
                                                   isLoggedIn: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AuthError.userNotFound
        }
        
        let snapshot = try await firestore.collection("users")
            .document(uid)
            .collection("LoginData")
            .document("loginInfo")
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
        try await firestore.collection("users")
            .document(uid)
            .collection("LoginData")
            .document("loginInfo")
            .setData(data, merge: true)
    }
    
    func deleteLoginDataFirestore() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentReference = firestore.collection("users")
            .document(uid)
            .collection("LoginData")
            .document("loginInfo")
        try await documentReference.delete()
    }
}
