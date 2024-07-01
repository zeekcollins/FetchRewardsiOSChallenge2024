//
//  NetworkErrorView.swift
//  MealDB
//
//  Created by Zeek Collins on 7/1/24.
//

import SwiftUI

/// A view that displays network error messages and a retry button.
struct NetworkErrorView: View {
    @ObservedObject var networkMonitor = NetworkMonitor.shared
    let errorMessage: String?
    let retryAction: (() -> Void)?
    @State private var isRetrying = false

    var body: some View {
        VStack(spacing: 20) {
            if isRetrying {
                // Show a loading indicator while retrying
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !networkMonitor.isConnected {
                errorMessageView(imageName: "wifi.exclamationmark", message: "No Internet Connection")
            } else if let errorMessage = errorMessage {
                errorMessageView(imageName: "exclamationmark.triangle.fill", message: errorMessage)
            }
        }
        .padding()
        .padding(.horizontal, 40)
    }
    
    /// A private function to create a view for displaying error messages and a retry button.
    /// - Parameters:
    ///   - imageName: The system image name to display with the error message.
    ///   - message: The error message to display.
    @ViewBuilder
    private func errorMessageView(imageName: String, message: String) -> some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .padding(.vertical, 20)
            Text(message)
                .font(.system(size: 24, weight: .light, design: .default))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        
        // Display retry button if a retry action is provided
        if let retryAction = retryAction {
            Button(action: {
                isRetrying = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isRetrying = false
                    retryAction()
                }
            }) {
                Text("Retry")
                    .font(.system(size: 24, weight: .semibold, design: .default))
                    .padding()
                    .frame(minWidth: 100)
                    .background(
                        Color(red: 246/255, green: 169/255, blue: 27/255)
                    )
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            .padding(.vertical, 20)
        }
    }
}

struct NetworkErrorView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkErrorView(errorMessage: "Failed to load data. Please check your internet connection and try again.") {}
    }
}
