//
//  ZoomButton.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 23.09.2025.
//

import SwiftUI

struct ZoomButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 44, height: 44)
                .background(.regularMaterial)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                .contentShape(Circle())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
