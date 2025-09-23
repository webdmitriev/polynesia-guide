//
//  SwipeButton.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 23.09.2025.
//

import SwiftUI

struct SwipeButton: View {
    let circleWidth: CGFloat = 52
    let padding: CGFloat = 2
    
    @State private var dragOffset: CGFloat = 0
    @State private var showSuccess = false
    
    var onSuccess: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - (padding * 2) - circleWidth
            let triggerThreshold = availableWidth * 0.95
            
            HStack {
                Circle()
                    .frame(width: circleWidth, height: circleWidth)
                    .zIndex(6)
                    .overlay(
                        Image(showSuccess ? "circle-btn-done" : "circle-btn")
                            .resizable()
                            .scaledToFill()
                    )
                    .offset(x: max(0, dragOffset), y: 4)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = min(value.translation.width, availableWidth)
                                
                                let reached = dragOffset >= triggerThreshold
                                if reached != showSuccess {
                                    showSuccess = reached
                                    if reached {
                                        onSuccess()
                                    }
                                }
                            }
                            .onEnded { _ in
                                if showSuccess {
                                    withAnimation(.spring()) {
                                        dragOffset = availableWidth
                                    }
                                    onSuccess()
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        dragOffset = 0
                                    }
                                }
                            }
                    )
                
                Text("Get Started")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .offset(y: 4)
                    .zIndex(2)
                
                Spacer(minLength: circleWidth)
            }
            .padding(.horizontal, padding)
        }
        .frame(height: 60)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appAccent.opacity(0.18),
                    Color.appAccent.opacity(0.3),
                    Color.appAccent.opacity(0.5)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 27))
        .overlay(
            RoundedRectangle(cornerRadius: 27)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.appAccent.opacity(0.18),
                            Color.appAccent.opacity(0.3),
                            Color.appAccent.opacity(0.5)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
        .padding(.horizontal, 16)


    }
}
