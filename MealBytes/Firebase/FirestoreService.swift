//
//  FirestoreService.swift
//  MealBytes
//
//  Created by Porshe on 21/03/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

protocol FirestoreServiceProtocol {
    func saveMealItem(_ mealItem: MealItem, completion: ((Error?) -> Void)?)
    func fetchMealItems(completion: @escaping ([MealItem]) -> Void)
}

final class FirestoreService: FirestoreServiceProtocol {
    private let firestore: Firestore
    
    init() {
        self.firestore = Firestore.firestore()
    }
    
    // MARK: - Save Data
    func saveMealItem(_ mealItem: MealItem, completion: ((Error?) -> Void)? = nil) {
        firestore.collection("meals").addDocument(data: mealItem.toDictionary()) { error in
            completion?(error)
        }
    }
    
    // MARK: - Fetch Data
    func fetchMealItems(completion: @escaping ([MealItem]) -> Void) {
        firestore.collection("meals").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                completion([])
                return
            }
            
            let mealItems = documents.compactMap { document -> MealItem? in
                let data = document.data()
                guard let idString = data["id"] as? String,
                      let id = UUID(uuidString: idString),
                      let foodId = data["foodId"] as? Int,
                      let foodName = data["foodName"] as? String,
                      let portionUnit = data["portionUnit"] as? String,
                      let nutrients = data["nutrients"] as? [String: Double],
                      let measurementDescription = data["measurementDescription"] as? String,
                      let amount = data["amount"] as? Double,
                      let date = (data["date"] as? Timestamp)?.dateValue(),
                      let mealTypeString = data["mealType"] as? String,
                      let mealType = MealType(rawValue: mealTypeString) else {
                    return nil
                }
                
                return MealItem(
                    id: id,
                    foodId: foodId,
                    foodName: foodName,
                    portionUnit: portionUnit,
                    nutrients: nutrients.reduce(into: [NutrientType: Double]()) { result, pair in
                        if let key = NutrientType(rawValue: pair.key) {
                            result[key] = pair.value
                        }
                    },
                    measurementDescription: measurementDescription,
                    amount: amount,
                    date: date,
                    mealType: mealType
                )
            }
            
            completion(mealItems)
        }
    }
}
