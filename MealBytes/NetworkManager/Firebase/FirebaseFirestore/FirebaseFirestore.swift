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
    func loadHistoryFirestore(for mealType: MealType) async throws -> [Food]
    func loadFoodMetadata(
        for mealType: MealType
    ) async throws -> [Int: FoodMetadata]
    func loadLoginDataFirestore() async throws -> (
        email: String,
        isLoggedIn: Bool
    )
    func loadMacrosIntakeFirestore() async throws -> MacrosIntake
    func loadPersonalIntakeFirestore() async throws -> PersonalIntakeData
    func loadCustomIntakeFirestore() async throws -> CustomIntake
    func loadCurrentIntakeFirestore() async throws -> CurrentIntake
    func loadDisplayIntakeFirestore() async throws -> Bool
    func addMealItemFirestore(_ mealItem: MealItem) async throws
    func addBookmarkFirestore(
        _ foods: [Food],
        for mealType: MealType
    ) async throws
    func addHistoryFirestore(
        _ foods: [Food],
        for mealType: MealType
    ) async throws
    func saveFoodMetadata(
        _ metadata: FoodMetadata,
        for mealType: MealType
    ) async throws
    func saveLoginDataFirestore(email: String, isLoggedIn: Bool) async throws
    func saveMacrosIntakeFirestore(
        _ MacrosIntakeData: MacrosIntake
    ) async throws
    func savePersonalIntakeFirestore(
        _ PersonalIntakeData: PersonalIntakeData
    ) async throws
    func saveCustomIntakeFirestore(_ customIntake: CustomIntake) async throws
    func saveCurrentIntakeFirestore(_ data: CurrentIntake) async throws
    func saveDisplayIntakeFirestore(_ displayIntake: Bool) async throws
    func updateMealItemFirestore(_ mealItem: MealItem) async throws
    func deleteMealItemFirestore(_ mealItem: MealItem) async throws
    func deleteMealItemsFirestore(on date: Date) async throws
    func deleteLoginDataFirestore() async throws
    func deleteFoodMetadata(
        for foodId: Int,
        foodName: String,
        mealType: MealType
    ) async throws
}

final class FirebaseFirestore: FirebaseFirestoreProtocol {
    private lazy var firestore = Firestore.firestore()
    
    // MARK: - Load Meal
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
    
    // MARK: - Save Meal
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
    
    // MARK: - Update Meal
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
    
    // MARK: - Delete Meal Item
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
    
    // MARK: - Delete Meal Items for Date
    func deleteMealItemsFirestore(on date: Date) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        guard let endOfDay = calendar.date(
            byAdding: .day,
            value: 1,
            to: startOfDay
        ) else {
            throw AppError.decoding
        }
        
        let startTimestamp = Timestamp(date: startOfDay)
        let endTimestamp = Timestamp(date: endOfDay)
        
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("MainView")
            .whereField("date", isGreaterThanOrEqualTo: startTimestamp)
            .whereField("date", isLessThan: endTimestamp)
            .getDocuments()
        
        let batch = firestore.batch()
        
        for document in snapshot.documents {
            batch.deleteDocument(document.reference)
        }
        
        try await batch.commit()
    }
    
    // MARK: - Load Foods SearchView
    private func loadFoodsFromFirestore(
        from collectionPath: String,
        for mealType: MealType
    ) async throws -> [Food] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("SearchView")
            .document(collectionPath)
            .collection(mealType.rawValue.lowercased())
            .document("items")
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
    
    // MARK: - Load Bookmarks
    func loadBookmarksFirestore(
        for mealType: MealType
    ) async throws -> [Food] {
        try await loadFoodsFromFirestore(from: "Bookmarks", for: mealType)
    }
    
    // MARK: - Load History
    func loadHistoryFirestore(
        for mealType: MealType
    ) async throws -> [Food] {
        try await loadFoodsFromFirestore(from: "History", for: mealType)
    }
    
    // MARK: - Save Foods SearchView
    private func saveFoodsToFirestore(
        _ foods: [Food],
        to collectionPath: String,
        for mealType: MealType
    ) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let encodedFoods = try foods.map { try Firestore.Encoder().encode($0) }
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("SearchView")
            .document(collectionPath)
            .collection(mealType.rawValue.lowercased())
            .document("items")
        
        try await documentReference.setData(
            ["items": encodedFoods],
            merge: true
        )
    }
    
    // MARK: - Add Bookmarks
    func addBookmarkFirestore(
        _ foods: [Food],
        for mealType: MealType
    ) async throws {
        try await saveFoodsToFirestore(foods, to: "Bookmarks", for: mealType)
    }
    
    // MARK: - Add History
    func addHistoryFirestore(
        _ foods: [Food],
        for mealType: MealType
    ) async throws {
        try await saveFoodsToFirestore(foods, to: "History", for: mealType)
    }
    
    // MARK: - Load Metadata for MealType
    func loadFoodMetadata(
        for mealType: MealType
    ) async throws -> [Int: FoodMetadata] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("SearchView")
            .document("Metadata")
            .collection(mealType.rawValue.lowercased())
            .getDocuments()
        
        var dict: [Int: FoodMetadata] = [:]
        for document in snapshot.documents {
            if let metadata = try? document.data(as: FoodMetadata.self) {
                dict[metadata.foodId] = metadata
            }
        }
        return dict
    }
    
    // MARK: - Save Metadata
    func saveFoodMetadata(
        _ metadata: FoodMetadata,
        for mealType: MealType
    ) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentId = "\(metadata.foodId)"
        
        let path = firestore
            .collection("Users")
            .document(uid)
            .collection("SearchView")
            .document("Metadata")
            .collection(mealType.rawValue.lowercased())
            .document(documentId)
        
        try path.setData(from: metadata, merge: true)
    }
    
    // MARK: - Delete Metadata
    func deleteFoodMetadata(
        for foodId: Int,
        foodName: String,
        mealType: MealType
    ) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentId = "\(foodId)"
        
        let path = firestore
            .collection("Users")
            .document(uid)
            .collection("SearchView")
            .document("Metadata")
            .collection(mealType.rawValue.lowercased())
            .document(documentId)
        
        try await path.delete()
    }
    
    // MARK: - Load MacrosIntake
    func loadMacrosIntakeFirestore() async throws -> MacrosIntake {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("MacrosIntakeView")
        
        return try await documentReference.getDocument(as: MacrosIntake.self)
    }
    
    // MARK: - Save MacrosIntake
    func saveMacrosIntakeFirestore(_ MacrosIntakeData: MacrosIntake) throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("MacrosIntakeView")
        
        try documentReference.setData(from: MacrosIntakeData)
    }
    
    // MARK: - Load PersonalIntake
    func loadPersonalIntakeFirestore() async throws -> PersonalIntakeData {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("PersonalIntakeView")
        
        return try await documentReference
            .getDocument(as: PersonalIntakeData.self)
    }
    
    // MARK: - Save PersonalIntake
    func savePersonalIntakeFirestore(_ personalIntakeData: PersonalIntakeData) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("PersonalIntakeView")
        
        try documentReference.setData(from: personalIntakeData)
    }
    
    // MARK: - Load CustomIntake
    func loadCustomIntakeFirestore() async throws -> CustomIntake {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("CustomIntake")
        
        return try await documentReference.getDocument(as: CustomIntake.self)
    }
    
    // MARK: - Save CustomIntake
    func saveCustomIntakeFirestore(_ customIntake: CustomIntake) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.decoding
        }
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("CustomIntake")
        
        try documentReference.setData(from: customIntake)
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
