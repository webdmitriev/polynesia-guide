//
//  PointType.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 23.09.2025.
//

import SwiftUI

enum PointType: String, CaseIterable {
    case hotel
    case beach
    case restaurant
    
    var imageName: String {
        switch self {
        case .hotel: return "building.fill"
        case .beach: return "sun.max.fill"
        case .restaurant: return "fork.knife.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .hotel: return .blue
        case .beach: return .yellow
        case .restaurant: return .orange
        }
    }
}
