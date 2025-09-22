//
//  FetchOnboardingRepositoryImp.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 22.09.2025.
//

import Foundation
import Combine

final class FetchOnboardingRepositoryImp: FetchOnboardingRepository {
    
    let dataSource: FetchOnboardingDataSource
    init(dataSource: FetchOnboardingDataSource) {
        self.dataSource = dataSource
    }
    
    func getOnboardingData() -> AnyPublisher<[OnboardingStruct], any Error> {
        self.dataSource.fetchOnboardingData()
    }
}
