//
//  OnboardingView.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 22.09.2025.
//

import SwiftUI
import Combine

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @State private var currentText: String = ""
    @State private var showContent = false
    
    @State private var dragOffset: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var showSuccess = false

    let circleWidth: CGFloat = 52
    let padding: CGFloat = 2
    
    init(viewModel: OnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            // Фон с размытием
            Color.black.ignoresSafeArea()
            
            VStack{}
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.appAccent.opacity(0.07),
                            Color.appAccent.opacity(0.15),
                            Color.appAccent.opacity(0.07)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else if viewModel.currentImages.count == 2 {
                onboardingContentView(viewModel.currentImages)
            }
        }
        .onAppear {
            viewModel.loadOnboardingData()
        }
        .onChange(of: viewModel.currentImages) { _, _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                showContent = true
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(2)
                .tint(.white)
            Text("Загрузка...")
                .foregroundColor(.white)
                .font(.title2)
                .padding(.top, 20)
        }
    }
    
    private func onboardingContentView(_ images: [OnboardingStruct]) -> some View {
        VStack {
            ZStack {
                OnboardingImageView(
                    url: images[0].url,
                    offsetX: 80,
                    offsetY: 190,
                    rotation: -6
                )
                
                OnboardingImageView(
                    url: images[1].url,
                    offsetX: -80,
                    offsetY: 50,
                    rotation: 4
                )
            }
            
            Spacer()
            
            VStack(spacing: 30) {
                OnboardingTitle(title: "Polynesia Guide! \n\(viewModel.randomText)")
                    .padding(.horizontal, 16)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)
                
                SwipeButton {
                    onReachEnd()
                }
            }
        }
    }
    
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Ошибка загрузки")
                .font(.title)
                .foregroundColor(.white)
            
            Text(error)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Попробовать снова") {
                viewModel.loadOnboardingData()
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundColor(.black)
        }
        .padding()
    }
    
    func onReachEnd() {
        print("✅ Успех! Переходим дальше...")
        
        // Через 1 секунду автоматический переход
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("🏁 Выполняем переход на новый View")
            // transitionToNextView()
        }
    }
    
}


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




