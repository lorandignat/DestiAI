//
//  CLLocationCoordinate2D+Equatable.swift
//  DestiAI
//
//  Created by Lorand Ignat on 24.04.2023.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
  static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}
