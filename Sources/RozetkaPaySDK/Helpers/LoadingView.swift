//
//  LoadingView.swift
//
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(2)
            
            Text("Operation in process...")
                .foregroundColor(.white)
                .font(.headline)
        }
        .padding(40)
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
    }
}
