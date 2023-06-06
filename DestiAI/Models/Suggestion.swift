//
//  Location.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import Foundation

struct Suggestion: Codable {
  var date: Date = Date()
  var location: String
  var description: String
  var suggestedActivities: [String: String]?
  var suggestedHotels: [String: String]?
  var images: [URL]?
  
  init(location: String, description: String) {
    self.location = location
    self.description = description
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    location = try container.decode(String.self, forKey: .location)
    description = try container.decode(String.self, forKey: .description)
    if let activities = try container.decodeIfPresent([String:String].self, forKey: .suggestedActivities) {
      self.suggestedActivities = activities
    }
    if let hotels = try container.decodeIfPresent([String:String].self, forKey: .suggestedHotels) {
      self.suggestedHotels = hotels
    }
    if let date = try container.decodeIfPresent(Date.self, forKey: .date) {
      self.date = date
    }
    if let images = try container.decodeIfPresent([URL].self, forKey: .images) {
      self.images = images
    }
  }
}
