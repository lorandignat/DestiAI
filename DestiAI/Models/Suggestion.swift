//
//  Location.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import Foundation

struct Suggestion: Codable {
  var location: String
  var description: String
  var weather: String
  var activities: [String: String]
  var hotels: [String: String]
}
