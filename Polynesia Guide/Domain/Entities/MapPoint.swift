//
//  MapPoint.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 23.09.2025.
//

import Foundation
import MapKit

struct MapPoint: Identifiable {
    let id = UUID()
    let title: String
    let type: PointType
    let coordinate: CLLocationCoordinate2D
}
