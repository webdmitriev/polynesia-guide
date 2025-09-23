//
//  OnboardingImageView.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 23.09.2025.
//

import SwiftUI

struct OnboardingImageView: View {
    let url: String
    let offsetX: CGFloat
    let offsetY: CGFloat
    let rotation: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                Color.black
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 280, height: 280)
                    .scaledToFill()
                    .overlay(Color.black.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .clipped()
                    .offset(x: offsetX, y: offsetY)
                    .rotationEffect(.degrees(rotation))
            case .failure:
                Color.gray.opacity(0.3)
            @unknown default:
                Color.black
            }
        }
    }
}
