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
    
    var onSkip: () -> Void
    
    init(viewModel: OnboardingViewModel, onSkip: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSkip = onSkip
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            onSkip()
        }
    }
    
}
