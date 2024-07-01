//
//  ContentView.swift
//  MealDB
//
//  Created by Zeek Collins on 6/28/24.
//

import SwiftUI

/// The main view for the MealDB app, displaying a list of meals or relevant error states.
struct ContentView: View {
    @State private var meals = [Meal]()
    @State private var isLoading = true
    @State private var errorMessage: String?
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    
    var body: some View {
        NavigationView {
            VStack {
                // Display the appropriate view based on network status and loading/error states
                if let error = errorMessage ?? (networkMonitor.isConnected ? nil : "No Internet Connection") {
                    NetworkErrorView(errorMessage: error, retryAction: {
                        Task {
                            await fetchData()
                        }
                    })
                } else if isLoading {
                    ProgressView("Loading Meals...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(meals, id: \.idMeal) { meal in
                        MealRow(meal: meal)
                    }
                    .navigationTitle("Desserts")
                }
            }
            .onAppear {
                // Fetch data when the view appears
                if meals.isEmpty {
                    Task {
                        await fetchData()
                    }
                }
            }
        }
    }
    
    func fetchData() async {
        // Check network connection status
        if !networkMonitor.isConnected {
            await MainActor.run {
                self.errorMessage = "No Internet Connection"
                self.isLoading = false
            }
            return
        }
        
        do {
            let detailedMeals = try await MealService.shared.fetchMeals()
            await MainActor.run {
                self.meals = detailedMeals
                self.isLoading = false
                self.errorMessage = nil
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load meals: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
