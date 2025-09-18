//
//  LoadingView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct LoadingView: View {
    var showLabel: Bool = false
    var showFrame: Bool = false
    
    var body: some View {
        let progressView = HStack {
            ProgressView()
            
            if showLabel {
                Text("Loading...")
                    .foregroundStyle(.secondary)
            }
        }
        
        if showFrame {
            progressView
                .frame(height: 50)
                .frame(maxWidth: .infinity)
        } else {
            progressView
        }
    }
}
