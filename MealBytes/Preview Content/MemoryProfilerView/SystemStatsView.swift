//
//  SystemStatsView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06/08/2025.
//

import SwiftUI

struct SystemStatsView: View {
    @StateObject private var systemStatsViewModel = SystemStatsViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("💾 RAM: \(String(format: "%.1f", systemStatsViewModel.usedMemoryMB)) MB")
            
            Text("⚙️ CPU: \(String(format: "%.1f", systemStatsViewModel.cpuUsage)) %")
            
            Text("🧵 Thread: \(systemStatsViewModel.threadCount)")
        }
        .font(.system(.caption, design: .monospaced))
        .padding()
    }
}



#Preview {
    PreviewContentView.contentView
}
