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
    func loadBookmarksFirebase() async throws -> [Int]
    func addMealItemFirebase(_ mealItem: MealItem) async throws
    func updateMealItemFirebase(_ mealItem: MealItem) async throws
    func deleteMealItemFirebase(_ mealItem: MealItem) async throws
    func saveBookmarkFirebase(food: Food) async throws
    func removeBookmarkFirebase(food: Food) async throws
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
    func addMealItemFirebase(_ mealItem: MealItem) async throws {
        let documentReference = firestore.collection("meals")
            .document(mealItem.id.uuidString)
        try documentReference.setData(from: mealItem)
    }
    
    // MARK: - Update Data
    func updateMealItemFirebase(_ mealItem: MealItem) async throws {
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
    func loadBookmarksFirebase() async throws -> [Int] {
        let snapshot = try await firestore.collection("bookmarks")
            .getDocuments()
        return snapshot.documents.compactMap { document in
            Int(document.documentID)
        }
    }
    
    // MARK: - Save bookmark
    func saveBookmarkFirebase(food: Food) async throws {
        let documentReference = firestore.collection("bookmarks")
            .document("\(food.searchFoodId)")
        try documentReference.setData(from: food)
    }
    
    // MARK: - Remove bookmark
    func removeBookmarkFirebase(food: Food) async throws {
        let documentReference = firestore.collection("bookmarks")
            .document("\(food.searchFoodId)")
        try await documentReference.delete()
    }
}
