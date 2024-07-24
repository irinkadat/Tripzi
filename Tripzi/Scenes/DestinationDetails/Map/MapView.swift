//
//  MapView.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 19.07.24.
//

import SwiftUI
import MapKit

struct MapView: View {
    var latitude: Double
    var longitude: Double
    var locationName: String
    
    init(latitude: Double, longitude: Double, locationName: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
    }
    
    var body: some View {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        Map() {
            Marker("\(locationName)", image: "pin", coordinate: location)
        }
        .cornerRadius(10)
    }
}

#Preview {
    MapView(latitude: 41.1, longitude: 41.1, locationName: "khodasheni")
}
