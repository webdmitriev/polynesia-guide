//
//  MapView.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 23.09.2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Map(position: $viewModel.cameraPosition) {
                
                // Отрисовываем все точки
                ForEach(viewModel.points) { point in
                    Annotation(point.title, coordinate: point.coordinate) {
                        MapPinView(point: point)
                            .onTapGesture {
                                viewModel.selectedPoint = point
                            }
                    }
                }
            }
            .mapStyle(.hybrid)
            .onMapCameraChange { context in
                viewModel.currentCamera = context.camera
            }
            
            VStack(spacing: 8) {
                ZoomButton(icon: "plus", action: viewModel.zoomIn)
                ZoomButton(icon: "minus", action: viewModel.zoomOut)
                ZoomButton(icon: "location.fill", action: viewModel.resetZoom)
            }
            .padding(.trailing, 16)
            .padding(.top, 60)
        }
        .sheet(item: $viewModel.selectedPoint) { point in
            VStack(spacing: 16) {
                Text(point.title)
                    .font(.title)
                    .bold()
                
                Image(systemName: point.type.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(point.type.color)
                
                Text("Координаты: \(point.coordinate.latitude), \(point.coordinate.longitude)")
                    .font(.footnote)
                
                Button("Закрыть") {
                    viewModel.selectedPoint = nil
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}
