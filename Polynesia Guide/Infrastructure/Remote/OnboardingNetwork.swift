//
//  OnboardingNetwork.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 22.09.2025.
//

import Foundation
import Combine

final class OnboardingNetwork: FetchOnboardingDataSource {
    
    func fetchOnboardingData() -> AnyPublisher<[OnboardingStruct], Error> {
        let urlString = "https://api.webdmitriev.com/wp-content/uploads/2025/09/polynesia-onboarding.json"

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [OnboardingStruct].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
