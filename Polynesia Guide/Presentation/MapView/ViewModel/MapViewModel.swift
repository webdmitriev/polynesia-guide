//
//  MapViewModel.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 23.09.2025.
//

import SwiftUI
import MapKit

final class MapViewModel: ObservableObject {
    
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var currentCamera: MapCamera?
    @Published var selectedPoint: MapPoint?
    
    @Published var points: [MapPoint] = [
        MapPoint(title: "Отель", type: .hotel,
                 coordinate: .init(latitude: -16.499, longitude: -151.735)),
        MapPoint(title: "Пляж", type: .beach,
                 coordinate: .init(latitude: -16.502, longitude: -151.74)),
        MapPoint(title: "Ресторан", type: .restaurant,
                 coordinate: .init(latitude: -16.497, longitude: -151.732))
    ]
    
    let islandCenter = CLLocationCoordinate2D(latitude: -16.50013, longitude: -151.73756)
    let boundingRadius: CLLocationDistance = 7000
    

    init() {
        let camera = MapCamera(centerCoordinate: islandCenter, distance: 7000 * 2)
        cameraPosition = .camera(camera)
        currentCamera = camera
    }
    
    // MARK: Methods
    func updateCamera(_ camera: MapCamera) {
        var clamped = camera
        
        // Ограничение расстояния (zoom)
        let minDistance: CLLocationDistance = 1000
        let maxDistance: CLLocationDistance = 30000
        clamped.distance = max(minDistance, min(maxDistance, clamped.distance))
        
        // Ограничение центра в пределах радиуса острова
        let currentLoc = CLLocation(latitude: clamped.centerCoordinate.latitude,
                                    longitude: clamped.centerCoordinate.longitude)
        let islandLoc = CLLocation(latitude: islandCenter.latitude,
                                   longitude: islandCenter.longitude)
        let distance = islandLoc.distance(from: currentLoc)
        
        if distance > boundingRadius {
            // Считаем азимут и "возвращаем" камеру на границу круга
            let bearing = atan2(
                clamped.centerCoordinate.longitude - islandCenter.longitude,
                clamped.centerCoordinate.latitude - islandCenter.latitude
            )
            
            let limitedCoord = coordinateAt(center: islandCenter,
                                            distance: boundingRadius,
                                            bearing: bearing)
            clamped.centerCoordinate = limitedCoord
        }
        
        withAnimation(.easeInOut) {
            cameraPosition = .camera(clamped)
            currentCamera = clamped
        }
    }

    
    func zoomIn() {
        guard var camera = currentCamera else { return }
        camera.distance /= 1.5
        updateCamera(camera)
    }
    
    func zoomOut() {
        guard var camera = currentCamera else { return }
        camera.distance *= 1.5
        updateCamera(camera)
    }
    
    func resetZoom() {
        let camera = MapCamera(centerCoordinate: islandCenter, distance: boundingRadius * 2)
        updateCamera(camera)
    }
    
    private func coordinateAt(center: CLLocationCoordinate2D,
                              distance: CLLocationDistance,
                              bearing: Double) -> CLLocationCoordinate2D {
        let R = 6_371_000.0
        
        let lat1 = center.latitude * .pi / 180
        let lon1 = center.longitude * .pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distance / R) +
                        cos(lat1) * sin(distance / R) * cos(bearing))
        
        let lon2 = lon1 + atan2(
            sin(bearing) * sin(distance / R) * cos(lat1),
            cos(distance / R) - sin(lat1) * sin(lat2)
        )
        
        return CLLocationCoordinate2D(
            latitude: lat2 * 180 / .pi,
            longitude: lon2 * 180 / .pi
        )
    }
}
