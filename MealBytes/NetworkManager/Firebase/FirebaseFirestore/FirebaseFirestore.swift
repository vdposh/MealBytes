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
    func loadSelectedSegmentFirestore() async throws -> String
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
    func loadDisplayGoalsFirestore() async throws -> Bool
    func loadEnergyUnitFirestore() async throws -> String
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
    func saveFoodMetadataBatch(
        _ metadata: [FoodMetadata],
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
    func saveDisplayGoalsFirestore(_ disabled: Bool) async throws
    func saveSelectedSegmentFirestore(_ segment: String) async throws
    func saveEnergyUnitFirestore(_ unit: String) async throws
    func updateMealItemFirestore(_ mealItem: MealItem) async throws
    func deleteMealItemFirestore(_ mealItem: MealItem) async throws
    func deleteMealItemsFirestore(on date: Date) async throws
    func deleteHistoryFirestore(for mealType: MealType) async throws
    func deleteLoginDataFirestore() async throws
    func deleteFoodMetadata(
        for foodId: Int,
        foodName: String,
        mealType: MealType
    ) async throws
    func deleteFoodMetadataBatch(
        for foodIds: [Int],
        mealType: MealType
    ) async throws
}

final class FirebaseFirestore: FirebaseFirestoreProtocol {
    private lazy var firestore = Firestore.firestore()
    
    private var currentUID: String {
        get throws {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw AuthError.userNotFound
            }
            return uid
        }
    }
    
    // MARK: - Load Meal
    func loadMealItemsFirestore() async throws -> [MealItem] {
        let uid = try currentUID
        
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
    func addMealItemFirestore(_ mealItem: MealItem) async throws {
        let uid = try currentUID
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("MainView")
            .document(mealItem.id.uuidString)
        
        try documentReference.setData(from: mealItem)
    }
    
    // MARK: - Update Meal
    func updateMealItemFirestore(_ mealItem: MealItem) async throws {
        let uid = try currentUID
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("MainView")
            .document(mealItem.id.uuidString)
        
        try documentReference.setData(from: mealItem, merge: true)
    }
    
    // MARK: - Delete Meal Item
    func deleteMealItemFirestore(_ mealItem: MealItem) async throws {
        let uid = try currentUID
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("MainView")
            .document(mealItem.id.uuidString)
        
        try await documentReference.delete()
    }
    
    // MARK: - Delete Meal Items for Date
    func deleteMealItemsFirestore(on date: Date) async throws {
        let uid = try currentUID
        
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
        let uid = try currentUID
        
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
    
    // MARK: - Delete History
    func deleteHistoryFirestore(for mealType: MealType) async throws {
        let uid = try currentUID
        try await firestore
            .collection("Users").document(uid)
            .collection("SearchView").document("History")
            .collection(mealType.rawValue.lowercased())
            .document("items")
            .delete()
    }
    
    // MARK: - Load Selected Segment
    func loadSelectedSegmentFirestore() async throws -> String {
        let uid = try currentUID
        
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("SearchView")
            .document("Segment")
            .getDocument()
        
        guard let data = snapshot.data(),
              let segment = data["segment"] as? String else {
            return ListSegment.bookmarks.rawValue
        }
        
        return segment
    }
    
    // MARK: - Save Selected Segment
    func saveSelectedSegmentFirestore(_ segment: String) async throws {
        let uid = try currentUID
        
        try await firestore
            .collection("Users")
            .document(uid)
            .collection("SearchView")
            .document("Segment")
            .setData(["segment": segment])
    }
    
    // MARK: - Save Foods SearchView
    private func saveFoodsToFirestore(
        _ foods: [Food],
        to collectionPath: String,
        for mealType: MealType
    ) async throws {
        let uid = try currentUID
        
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
        let uid = try currentUID
        
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
        let uid = try currentUID
        
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
    
    // MARK: - Save Metadata Batch
    func saveFoodMetadataBatch(
        _ metadata: [FoodMetadata],
        for mealType: MealType
    ) async throws {
        guard !metadata.isEmpty else { return }
        
        let uid = try currentUID
        let batch = firestore.batch()
        
        for item in metadata {
            let ref = firestore
                .collection("Users").document(uid)
                .collection("SearchView").document("Metadata")
                .collection(mealType.rawValue.lowercased())
                .document("\(item.foodId)")
            
            try batch.setData(
                from: item,
                forDocument: ref,
                merge: true
            )
        }
        
        try await batch.commit()
    }
    
    // MARK: - Delete Metadata
    func deleteFoodMetadata(
        for foodId: Int,
        foodName: String,
        mealType: MealType
    ) async throws {
        let uid = try currentUID
        
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
    
    func deleteFoodMetadataBatch(
        for foodIds: [Int],
        mealType: MealType
    ) async throws {
        guard !foodIds.isEmpty else { return }
        
        let uid = try currentUID
        let batch = firestore.batch()
        
        for id in foodIds {
            let ref = firestore
                .collection("Users").document(uid)
                .collection("SearchView").document("Metadata")
                .collection(mealType.rawValue.lowercased())
                .document("\(id)")
            
            batch.deleteDocument(ref)
        }
        
        try await batch.commit()
    }
    
    // MARK: - Load PersonalIntake
    func loadPersonalIntakeFirestore() async throws -> PersonalIntakeData {
        let uid = try currentUID
        
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
        let uid = try currentUID
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("PersonalIntakeView")
        
        try documentReference.setData(from: personalIntakeData)
    }
    
    // MARK: - Load MacrosIntake
    func loadMacrosIntakeFirestore() async throws -> MacrosIntake {
        let uid = try currentUID
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("MacrosIntakeView")
        
        return try await documentReference.getDocument(as: MacrosIntake.self)
    }
    
    // MARK: - Save MacrosIntake
    func saveMacrosIntakeFirestore(
        _ MacrosIntakeData: MacrosIntake
    ) async throws {
        let uid = try currentUID
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("MacrosIntakeView")
        
        try documentReference.setData(from: MacrosIntakeData)
    }
    
    // MARK: - Load CustomIntake
    func loadCustomIntakeFirestore() async throws -> CustomIntake {
        let uid = try currentUID
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("CustomIntakeView")
        
        return try await documentReference.getDocument(as: CustomIntake.self)
    }
    
    // MARK: - Save CustomIntake
    func saveCustomIntakeFirestore(_ customIntake: CustomIntake) async throws {
        let uid = try currentUID
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("CustomIntakeView")
        
        try documentReference.setData(from: customIntake)
    }
    
    // MARK: - Load Intake
    func loadCurrentIntakeFirestore() async throws -> CurrentIntake {
        let uid = try currentUID
        
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
        let uid = try currentUID
        
        let documentReference = firestore
            .collection("Users")
            .document(uid)
            .collection("GoalsView")
            .document("CurrentIntake")
        
        try documentReference.setData(from: data)
    }
    
    // MARK: - Load Goals Disabled
    func loadDisplayGoalsFirestore() async throws -> Bool {
        let uid = try currentUID
        
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("DisplayGoals")
            .getDocument()
        
        guard let data = snapshot.data(),
              let display = data["display"] as? Bool else {
            return true
        }
        
        return display
    }
    
    // MARK: - Save Display Goals
    func saveDisplayGoalsFirestore(_ display: Bool) async throws {
        let uid = try currentUID
        
        try await firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("DisplayGoals")
            .setData(["display": display])
    }
    
    // MARK: - Load Energy Unit
    func loadEnergyUnitFirestore() async throws -> String {
        let uid = try currentUID
        
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("EnergyUnit")
            .getDocument()
        
        guard let data = snapshot.data(),
              let unit = data["unit"] as? String else {
            return EnergyUnit.kcal.rawValue
        }
        
        return unit
    }
    
    // MARK: - Save Energy Unit
    func saveEnergyUnitFirestore(_ unit: String) async throws {
        let uid = try currentUID
        
        try await firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("EnergyUnit")
            .setData(["unit": unit])
    }
    
    // MARK: - Current User
    func loadLoginDataFirestore() async throws -> (
        email: String,
        isLoggedIn: Bool
    ) {
        let uid = try currentUID
        
        let snapshot = try await firestore
            .collection("Users")
            .document(uid)
            .collection("ProfileView")
            .document("LoginInfo")
            .getDocument()
        
        guard let data = snapshot.data(),
              let email = data["email"] as? String,
              let isLoggedIn = data["isLoggedIn"] as? Bool else {
            return ("", false)
        }
        
        return (email, isLoggedIn)
    }
    
    func saveLoginDataFirestore(
        email: String,
        isLoggedIn: Bool
    ) async throws {
        let uid = try currentUID
        
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
        let uid = try currentUID
        
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
