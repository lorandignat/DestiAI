//
//  IdentifiableLocation.swift
//  DestiAI
//
//  Created by Lorand Ignat on 24.04.2023.
//

import Foundation
import MapKit

struct IdentifiableLocation: Identifiable {
  var id: UUID
  var coordinate: CLLocationCoordinate2D
}
