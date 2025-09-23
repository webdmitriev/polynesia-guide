//
//  MapView.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 23.09.2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    // 1. Определяем координаты центра острова
    let islandCenter = CLLocationCoordinate2D(latitude: -16.50013, longitude: -151.73756)
    // 2. Задаем радиус ограничения (5 км в метрах)
    let boundingRadius: CLLocationDistance = 7000

    // 3. Вычисляем регион, который будет виден на карте изначально
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        // 4. Создаем границы для камеры карты
        let bounds = MapCameraBounds(centerCoordinateBounds: .init(center: islandCenter, latitudinalMeters: boundingRadius * 2, longitudinalMeters: boundingRadius * 2),
                                    minimumDistance: 1000,
                                    maximumDistance: 30000)

        Map(position: $cameraPosition, bounds: bounds)
            .mapStyle(.hybrid)
            .controlSize(.large)
            .onAppear {
                // 5. Устанавливаем начальную позицию камеры в центр острова
                cameraPosition = .region(MKCoordinateRegion(center: islandCenter, latitudinalMeters: boundingRadius * 2, longitudinalMeters: boundingRadius * 2))
            }
    }
}
