//
//  String+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

extension String {
    var sanitizedForDouble: String {
        self.replacingOccurrences(of: ",", with: ".")
    }
    
    func pluralized(for amount: Double) -> String {
        guard amount != 1 else { return self }
        
        let parts = self.components(separatedBy: " (")
        let mainDescription = parts[0]
        let suffix = parts.count > 1 ? " (\(parts[1])" : ""
        
        var words = mainDescription.split(separator: " ").map(String.init)
        
        for (index, word) in words.enumerated() {
            let cleanWord = word.trimmingCharacters(
                in: .punctuationCharacters
            ).lowercased()
            if let plural = Pluralizer.rules[cleanWord] {
                let hasComma = word.contains(",")
                words[index] = plural + (hasComma ? "," : "")
                break
            }
        }
        
        let result = words.joined(separator: " ") + suffix
        return result
    }
}

enum Pluralizer {
    static let rules: [String: String] = [
        // 🥩 Proteins and meat items
        "breast": "breasts",
        "drumstick": "drumsticks",
        "leg": "legs",
        "wing": "wings",
        "fillet": "fillets",
        "patty": "patties",
        "meatball": "meatballs",
        "sausage": "sausages",
        "strip": "strips",
        "tender": "tenders",
        "skewer": "skewers",
        "kebab": "kebabs",
        "pop": "pops",
        
        // 🥦 Fruits and vegetables
        "apple": "apples",
        "banana": "bananas",
        "carrot": "carrots",
        "plum": "plums",
        "cherry": "cherries",
        "grape": "grapes",
        "olive": "olives",
        "tomato": "tomatoes",
        "potato": "potatoes",
        "onion": "onions",
        "cucumber": "cucumbers",
        "pea": "peas",
        "bean": "beans",
        "leaf": "leaves",
        "globe": "globes",
        "clove": "cloves",
        
        // 🧀 Shapes and chunks
        "cube": "cubes",
        "ball": "balls",
        "slice": "slices",
        "stick": "sticks",
        "block": "blocks",
        "triangle": "triangles",
        "wedge": "wedges",
        "half": "halves",
        "quarter": "quarters",
        "third": "thirds",
        
        // 🍞 Baked goods and snacks
        "loaf": "loaves",
        "roll": "rolls",
        "biscuit": "biscuits",
        "cookie": "cookies",
        "cracker": "crackers",
        "muffin": "muffins",
        "bun": "buns",
        "bar": "bars",
        
        // 🥣 Containers and packaging
        "serving": "servings",
        "cup": "cups",
        "glass": "glasses",
        "bottle": "bottles",
        "packet": "packets",
        "pouch": "pouches",
        "can": "cans",
        "container": "containers",
        "jar": "jars",
        "bag": "bags",
        "box": "boxes",
        "carton": "cartons",
        "case": "cases",
        "pack": "packs",
        "tray": "trays",
        "dropper": "droppers",
        
        // 🥄 Doses and small units
        "scoop": "scoops",
        "teaspoon": "teaspoons",
        "tablespoon": "tablespoons",
        "drop": "drops",
        "capsule": "capsules",
        "tablet": "tablets",
        "pill": "pills",
        "softgel": "softgels",
        "chewable": "chewables",
        "gummy": "gummies",
        "spray": "sprays",
        
        // 🧂 Spices and seasonings
        "pinch": "pinches",
        "dash": "dashes",
        "sprinkle": "sprinkles",
        "grind": "grinds",
        "sheet": "sheets",
        "disk": "disks",
        
        // ⚙️ General units
        "item": "items",
        "unit": "units",
        "portion": "portions",
        "piece": "pieces",
        "bundle": "bundles"
    ]
}
