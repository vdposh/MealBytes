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
    func addMealItemFirebase(_ mealItem: MealItem) async throws
    func loadMealItemsFirebase() async throws -> [MealItem]
    func deleteMealItemFirebase(_ mealItem: MealItem) async throws
    func updateMealItemFirebase(_ mealItem: MealItem) async throws
    func saveBookmark(foodId: Int) async throws
    func removeBookmark(foodId: Int) async throws
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
    
    func saveBookmark(foodId: Int) async throws {
        let documentReference = firestore.collection("bookmarks").document("\(foodId)")
        try await documentReference.setData(["timestamp": Timestamp()])
    }
    
    func removeBookmark(foodId: Int) async throws {
        let documentReference = firestore.collection("bookmarks").document("\(foodId)")
        try await documentReference.delete()
    }
}
