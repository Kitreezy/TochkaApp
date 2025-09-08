//
//  PlaceAnnotation.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

public class PlaceMapAnnotation: NSObject, MKAnnotation, ObservableObject, Identifiable {
    public let id: String
    public let place: Place
    
    public var coordinate: CLLocationCoordinate2D {
        place.coordinate
    }
    
    public var title: String? {
        place.name
    }
    
    public var subtitle: String? {
        place.description
    }

    public var clusteringIdentifier: String? {
        return place.category.rawValue
    }
    
    public init(place: Place) {
        self.id = place.id
        self.place = place
        super.init()
    }
}
