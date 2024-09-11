//
//  CoordinateUtils.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 09.09.24.
//

import Foundation
import CoreLocation

struct CoordinateUtils {
    static func calculateCenter(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        let minLat = latitudes.min() ?? 0
        let maxLat = latitudes.max() ?? 0
        let minLong = longitudes.min() ?? 0
        let maxLong = longitudes.max() ?? 0
        return CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2)
    }
}
