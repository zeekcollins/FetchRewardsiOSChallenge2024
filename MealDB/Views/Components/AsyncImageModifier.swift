//
//  AsyncImageModifier.swift
//  MealDB
//
//  Created by Zeek Collins on 6/30/24.
//

import SwiftUI

/// A view builder function that applies modifiers to an image for consistent styling.
/// - Parameter image: The image to be styled.
/// - Returns: A view that displays the image with the applied modifiers.
@ViewBuilder
func imageModifier(image: Image) -> some View {
    image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(maxWidth: .infinity, maxHeight: 100)
        .clipped()
        .cornerRadius(10)
}

struct AsyncImageModifier_Previews: PreviewProvider {
    static var previews: some View {
        imageModifier(image: Image(systemName: "photo"))
    }
}
