//
//  MealService.swift
//  MealDB
//
//  Created by Zeek Collins on 6/30/24.
//

import Foundation

/// A service class to handle fetching meal data from the MealDB API.
class MealService {
    static let shared = MealService()
    
    private init() {}
    
    /// Fetches a list of meals from the MealDB API.
    /// - Throws: An error if the URL is invalid or if the network request fails.
    /// - Returns: An array of `Meal` objects.
    func fetchMeals() async throws -> [Meal] {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
        var detailedMeals: [Meal] = []
        
        // Fetch detailed information for each meal in parallel.
        await withTaskGroup(of: Meal?.self) { group in
            for meal in decodedResponse.meals {
                group.addTask {
                    return await self.fetchMealDetails(id: meal.idMeal)
                }
            }
            
            // Collect detailed meal information.
            for await detailedMeal in group {
                if let detailedMeal = detailedMeal {
                    detailedMeals.append(detailedMeal)
                }
            }
        }
        
        detailedMeals.sort { $0.strMeal < $1.strMeal }
        return detailedMeals
    }
    
    /// Fetches detailed information for a specific meal by its ID.
    /// - Parameter id: The ID of the meal to fetch details for.
    /// - Returns: An optional `Meal` object containing detailed information.
    func fetchMealDetails(id: String) async -> Meal? {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            print("Invalid URL for meal details")
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
            return decodedResponse.meals.first
        } catch {
            print("Failed to fetch meal details: \(error)")
            return nil
        }
    }
}
