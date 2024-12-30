//
//  Entry.swift
//  LiSerenaFinalProject
//
//  Created by Serena Li.
//

import Foundation
import CoreLocation
import MapKit

// model for markers on the map
// cannot directly use marker because not identifiable
struct Entry: Identifiable {
    let id = UUID()
    let entry_time: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
//    let image: Image <- possible extension of showing images when clicking on the markers
}
