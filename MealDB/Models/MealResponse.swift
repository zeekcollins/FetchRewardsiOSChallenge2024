//
//  MealResponse.swift
//  MealDB
//
//  Created by Zeek Collins on 6/30/24.
//

import Foundation

/// A struct representing an array of Meal objects.
struct MealResponse: Codable {
    var meals: [Meal]
}
