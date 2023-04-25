//
//  GeocoderService.swift
//  DestiAI
//
//  Created by Lorand Ignat on 24.04.2023.
//

import Foundation

protocol GeocoderService {
  func data(for coordinates: (lat: Double, long: Double)) async -> String?
}
