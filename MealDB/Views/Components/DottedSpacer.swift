//
//  DottedSpacer.swift
//  MealDB
//
//  Created by Zeek Collins on 6/30/24.
//

import SwiftUI

/// A custom view that creates a horizontal row of dots to be used as a spacer.
struct DottedSpacer: View {
    var body: some View {
        GeometryReader { geometry in
            let dotWidth: CGFloat = 5
            
            // Calculate the number of dots that fit in the available width.
            let numberOfDots = Int(geometry.size.width / dotWidth)
            HStack(spacing: 0) {
                ForEach(0..<numberOfDots, id: \.self) { _ in
                    Text(".")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: dotWidth)
                }
            }
        }
        .frame(height: 10)
    }
}

struct DottedSpacer_Previews: PreviewProvider {
    static var previews: some View {
        DottedSpacer()
            .frame(width: 200)
            .padding()
    }
}
