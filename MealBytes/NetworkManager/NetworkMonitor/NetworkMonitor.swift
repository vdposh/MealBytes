//
//  NetworkMonitor.swift
//  MealBytes
//
//  Created by Porshe on 07/04/2025.
//

import SwiftUI
import Network

final class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected: Bool?

    private var didUpdateConnection: (() -> Void)?
    
    init() {
        monitor.pathUpdateHandler = { path in
            Task {
                await MainActor.run {
                    self.isConnected = path.status == .satisfied
                    self.didUpdateConnection?()
                    self.didUpdateConnection = nil
                }
            }
        }
        monitor.start(queue: queue)
    }

    func waitForConnectionUpdate() async {
        if isConnected == nil {
            await withCheckedContinuation { continuation in
                self.didUpdateConnection = {
                    continuation.resume()
                }
            }
        }
    }
}
