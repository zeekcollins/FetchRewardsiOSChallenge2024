//
//  MealDetailView.swift
//  MealDB
//
//  Created by Zeek Collins on 6/30/24.
//

import SwiftUI

/// A view that displays a meal's instructions, ingredients, and measurements.
struct MealDetailView: View {
    var meal: Meal
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    ResizableText(text: meal.strMeal)
                        .padding(.bottom, 8)
                    Spacer()
                }
                
                AsyncImage(url: URL(string: meal.strMealThumb)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .clipped()
                            .cornerRadius(10)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .clipped()
                            .cornerRadius(10)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    }
                }
                
                if let instructions = meal.strInstructions {
                    Text("Instructions")
                        .font(.title2)
                        .padding(.vertical, 8)
                        .underline()
                    
                    Text(instructions)
                        .font(.body)
                }
                
                Text("Ingredients & Measurements")
                    .font(.title2)
                    .padding(.vertical, 8)
                    .underline()
                
                // Iterate through ingredients and measurements and display them in a list
                ForEach(Array(meal.ingredientsAndMeasurements().enumerated()), id: \.offset) { index, pair in
                    let (ingredient, measure) = pair
                    HStack {
                        Text(ingredient)
                            .fixedSize(horizontal: true, vertical: false)
                        
                        // Put dots in between corresponding ingredients and measurements
                        DottedSpacer()
                        Text(measure)
                    }
                    .font(.body)
                }
                Spacer()
            }
            .padding(.all, 30.0)
            .navigationTitle("Meal Details")
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeal = Meal(idMeal: "52893", strMeal: "Apple & Blackberry Crumble", strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg", strInstructions: "Instructions here...", strIngredient1: "Apple", strIngredient2: "Blackberry", strMeasure1: "1 cup", strMeasure2: "2 cups")
        MealDetailView(meal: sampleMeal)
    }
}
