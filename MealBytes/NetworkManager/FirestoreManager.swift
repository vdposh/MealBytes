//
//  FirestoreManager.swift
//  MealBytes
//
//  Created by Porshe on 21/03/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

protocol FirestoreManagerProtocol {
    func loadMealItemsFirebase() async throws -> [MealItem]
    func loadBookmarksFirebase() async throws -> [Food]
    func loadCustomRdiFirebase() async throws -> CustomRdiData
    func saveCustomRdiFirebase(_ customGoalsData: CustomRdiData) async throws
    func addMealItemFirebase(_ mealItem: MealItem) async throws
    func updateMealItemFirebase(_ mealItem: MealItem) async throws
    func deleteMealItemFirebase(_ mealItem: MealItem) async throws
    func addBookmarkFirebase(_ foods: [Food]) async throws
}

final class FirestoreManager: FirestoreManagerProtocol {
    private let firestore: Firestore
    
    init() {
        self.firestore = Firestore.firestore()
    }
    
    // MARK: - Fetch Data
    func loadMealItemsFirebase() async throws -> [MealItem] {
        let snapshot = try await firestore.collection("meals").getDocuments()
        return try snapshot.documents.compactMap { document in
            try document.data(as: MealItem.self)
        }
    }
    
    // MARK: - Save Data
    func addMealItemFirebase(_ mealItem: MealItem) throws {
        let documentReference = firestore.collection("meals")
            .document(mealItem.id.uuidString)
        try documentReference.setData(from: mealItem)
    }
    
    // MARK: - Update Data
    func updateMealItemFirebase(_ mealItem: MealItem) throws {
        let documentReference = firestore.collection("meals")
            .document(mealItem.id.uuidString)
        try documentReference.setData(from: mealItem, merge: true)
    }
    
    // MARK: - Delete Data
    func deleteMealItemFirebase(_ mealItem: MealItem) async throws {
        let documentReference = firestore.collection("meals")
            .document(mealItem.id.uuidString)
        try await documentReference.delete()
    }
    
    // MARK: - Load bookmarks
    func loadBookmarksFirebase() async throws -> [Food] {
        let snapshot = try await firestore.collection("favoriteFoods")
            .document("favorites").getDocument()
        
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
    func addBookmarkFirebase(_ foods: [Food]) async throws {
        let data = try foods.map { food in
            try Firestore.Encoder().encode(food)
        }
        try await firestore.collection("favoriteFoods")
            .document("favorites")
            .setData(["foods": data])
    }
    
    // MARK: - Save customRDI Data
    func saveCustomRdiFirebase(_ customGoalsData: CustomRdiData) throws {
        let documentReference = firestore.collection("userCustomGoals")
            .document("currentCustomGoals")
        try documentReference.setData(from: customGoalsData)
    }
    
    // MARK: - Load customRDI Data
    func loadCustomRdiFirebase() async throws -> CustomRdiData {
        let snapshot = try await firestore.collection("userCustomGoals")
            .document("currentCustomGoals").getDocument()
        guard let data = snapshot.data() else {
            throw AppError.decoding
        }
        return try CustomRdiData(data: data)
    }
}
