//
//  ResizableText.swift
//  MealDB
//
//  Created by Zeek Collins on 6/30/24.
//

import SwiftUI

/// A view that displays resizable text, adjusting the font size to fit within the available width.
struct ResizableText: View {
    var text: String
    
    @State private var fontSize: CGFloat = 34
    
    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .font(.system(size: fontSize, weight: .light, design: .default))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .background(
                    TextSizer(text: text, fontSize: $fontSize, availableWidth: geometry.size.width)
                        .hidden()
                )
                .frame(maxWidth: .infinity)
        }
        .frame(height: fontSize)
    }
}

/// A helper view that adjusts the font size of the text to fit within the available width.
struct TextSizer: View {
    var text: String
    @Binding var fontSize: CGFloat
    var availableWidth: CGFloat
    
    var body: some View {
        Text(text)
            .font(.system(size: fontSize))
            .background(GeometryReader { innerGeometry in
                Color.clear
                    .onAppear {
                        adjustFontSize(geometry: innerGeometry)
                    }
                    .onChange(of: innerGeometry.size.width) {
                        adjustFontSize(geometry: innerGeometry)
                    }
            })
    }
    
    /// Adjusts the font size based on the available width and the text's width.
    /// - Parameter geometry: The geometry proxy of the text view.
    private func adjustFontSize(geometry: GeometryProxy) {
        if geometry.size.width > availableWidth {
            fontSize -= 1
        }
    }
}

struct ResizableText_Previews: PreviewProvider {
    static var previews: some View {
        ResizableText(text: "Carrot Cake")
            .padding()
    }
}
