//
//  NetworkMonitor.swift
//  MealDB
//
//  Created by Zeek Collins on 7/1/24.
//

import Network
import SwiftUI

/// A class to monitor network connectivity changes.
class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    // Internal initializer for testing or preview purposes
    internal init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}
