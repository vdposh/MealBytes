//
//  String+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

extension String {
    var trimmedLeadingZeros: String {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }
        
        guard let number = trimmed.doubleValue else { return self }
        
        if number == 0 {
            return ""
        }
        
        let isInteger = number.truncatingRemainder(dividingBy: 1) == 0
        return isInteger ? number
            .asWhole(grouping: false) : number
            .asDecimal(grouping: false)
    }
    
    func isValidNumericInput(in range: ClosedRange<Double>? = nil) -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        
        guard let value = trimmed.doubleValue, value > 0 else {
            return false
        }
        
        if let range {
            return range.contains(value)
        }
        
        return true
    }
    
    var doubleValue: Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)?.doubleValue
    }
    
    // MARK: - Text
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
        
        return words.joined(separator: " ") + suffix
    }
    
    private enum Pluralizer {
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
            "taco": "tacos",
            "burrito": "burritos",
            "dumpling": "dumplings",
            "omelet": "omelets",
            "salad": "salads",
            "curry": "curries",
            "stew": "stews",
            "soup": "soups",
            "quesadilla": "quesadillas",
            "wrap": "wraps",
            "bowl": "bowls",
            
            // 🥦 Fruits and vegetables
            "apple": "apples",
            "banana": "bananas",
            "carrot": "carrots",
            "floweret": "flowerets",
            "floret": "florets",
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
            "sprout": "sprouts",
            "berry": "berries",
            "stalk": "stalks",
            
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
            "ring": "rings",
            "square": "squares",
            "dome": "domes",
            "rectangle": "rectangles",
            
            // 🍞 Baked goods and snacks
            "loaf": "loaves",
            "roll": "rolls",
            "biscuit": "biscuits",
            "cookie": "cookies",
            "cracker": "crackers",
            "muffin": "muffins",
            "bun": "buns",
            "bar": "bars",
            "sandwich": "sandwiches",
            "pizza": "pizzas",
            "waffle": "waffles",
            "pancake": "pancakes",
            "crepe": "crepes",
            "cupcake": "cupcakes",
            "tart": "tarts",
            "brownie": "brownies",
            "éclair": "éclairs",
            "pastry": "pastries",
            
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
            "tub": "tubs",
            "sleeve": "sleeves",
            "pod": "pods",
            "ampoule": "ampoules",
            "vial": "vials",
            "blister": "blisters",
            "strip pack": "strip packs",
            
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
            "shot": "shots",
            "patch": "patches",
            "inhaler": "inhalers",
            
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
            "bundle": "bundles",
            "inch": "inches",
            "ounce": "ounces",
            "liter": "liters",
            "portion pack": "portion packs",
            "bite": "bites",
            "stack": "stacks"
        ]
    }
}
