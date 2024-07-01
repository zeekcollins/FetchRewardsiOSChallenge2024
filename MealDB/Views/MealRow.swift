//
//  MealRow.swift
//  MealDB
//
//  Created by Zeek Collins on 6/30/24.
//

import SwiftUI

/// A view that displays a single meal row with its image and name.
/// Handles image loading with retry logic in case of failure.
struct MealRow: View {
    let meal: Meal
    @State private var imageURL: URL?
    @State private var retryCount = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text(meal.strMeal)
                .font(.system(size: 24, weight: .thin, design: .default))
            
            // Load and display the meal image with retry logic
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    imageModifier(image: image)
                    let _ = DispatchQueue.main.async {
                        retryCount = 0
                    }
                case .failure(_):
                    // Failed to load image, retry up to 3 times
                    let _ = DispatchQueue.main.async {
                        if retryCount < 3 {
                            retryCount += 1
                            imageURL = URL(string: meal.strMealThumb + "?\(retryCount)")
                        } else {
                            let _ = imageModifier(image: Image(systemName: "photo"))
                        }
                    }
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: 125)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 125)
            .onAppear {
                imageURL = URL(string: meal.strMealThumb)
            }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
        .padding(.vertical, 5)
        .listRowSeparator(.visible, edges: .bottom)
        .background(
            NavigationLink(
                destination: MealDetailView(meal: meal)) {
                    EmptyView()
                }
                .opacity(0)
        )
    }
}

struct MealRow_Previews: PreviewProvider {
    static var previews: some View {
        // A sample meal for the preview
        MealRow(meal: Meal(
            idMeal: "52855",
            strMeal: "Banana Pancakes",
            strMealThumb: "https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg",
            strInstructions: nil,
            strIngredient1: nil,
            strIngredient2: nil,
            strIngredient3: nil,
            strIngredient4: nil,
            strIngredient5: nil,
            strIngredient6: nil,
            strIngredient7: nil,
            strIngredient8: nil,
            strIngredient9: nil,
            strIngredient10: nil,
            strIngredient11: nil,
            strIngredient12: nil,
            strIngredient13: nil,
            strIngredient14: nil,
            strIngredient15: nil,
            strIngredient16: nil,
            strIngredient17: nil,
            strIngredient18: nil,
            strIngredient19: nil,
            strIngredient20: nil,
            strMeasure1: nil,
            strMeasure2: nil,
            strMeasure3: nil,
            strMeasure4: nil,
            strMeasure5: nil,
            strMeasure6: nil,
            strMeasure7: nil,
            strMeasure8: nil,
            strMeasure9: nil,
            strMeasure10: nil,
            strMeasure11: nil,
            strMeasure12: nil,
            strMeasure13: nil,
            strMeasure14: nil,
            strMeasure15: nil,
            strMeasure16: nil,
            strMeasure17: nil,
            strMeasure18: nil,
            strMeasure19: nil,
            strMeasure20: nil
        ))
    }
}
