//
//  MapView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 19.07.24.
//

import SwiftUI
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let name: String
}

struct MapView: View {
    var locations: [MapLocation]
    
    var body: some View {
        let coordinates = locations.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        
        @State var region = MKCoordinateRegion(
            center: CoordinateUtils.calculateCenter(for: coordinates),
            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        )
        
        var initialPosition: MapCameraPosition {
            let region = region
            return .region(region)
        }
        
        Map(coordinateRegion: .constant(region), annotationItems: locations, annotationContent: { location in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                VStack {
                    Text(location.name)
                        .font(.system(size: 11))
                        .frame(width: 80)
                        .lineLimit(3)
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }
        })
        .cornerRadius(10)
    }
}

