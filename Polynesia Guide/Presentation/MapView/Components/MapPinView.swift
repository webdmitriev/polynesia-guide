//
//  MapPinView.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 23.09.2025.
//

import SwiftUI

struct MapPinView: View {
    let point: MapPoint
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: point.type.imageName)
                .foregroundColor(.white)
                .padding(8)
                .background(point.type.color)
                .clipShape(Circle())
                .shadow(radius: 3)
            
            // стрелочка вниз (указатель)
            Triangle()
                .fill(point.type.color)
                .frame(width: 12, height: 8)
                .rotationEffect(.degrees(180))
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
