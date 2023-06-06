//
//  PromptData.swift
//  DestiAI
//
//  Created by Lorand Ignat on 19.04.2023.
//

import Foundation

enum PromptCategory: Int, CaseIterable {
  case distance = 0
  case period
  case budget
  case weather
  case activities
}

struct PromptData {
  
  static func numberOfCategories() -> Int {
    PromptCategory.allCases.count
  }
  
  static func question(for category: Int) -> String {
    guard let promptCategory = PromptCategory(rawValue: category) else {
      return ""
    }
    switch promptCategory {
    case .distance:
      return "How far do you want to travel?"
    case .period:
      return "When do you plan to go on this trip?"
    case .budget:
      return "What is your budget?"
    case .weather:
      return "What weather do you prefer?"
    case .activities:
      return "What do you want to do on this trip?"
    }
  }
  
  static func options(for category: Int) -> [String] {
    guard let promptCategory = PromptCategory(rawValue: category) else {
      return []
    }
    var options = [String]()
    for elements in Self.promptOptions(for: promptCategory) {
      options.append(elements.option)
    }
    
    return options
  }
  
  static func prompt(for values: [Int: Int], city: String?) -> String {
    
    var distance: String?
    var period: String?
    var budget: String?
    var weather: String?
    var activities: String?
    
    for key in values.keys {
      if let promptCategory = PromptCategory(rawValue: key) {
        if let option = values[key] {
          switch promptCategory {
          case .distance:
            distance = Self.promptOptions(for: promptCategory)[option].prompt
          case .period:
            period = Self.promptOptions(for: promptCategory)[option].prompt
          case .budget:
            budget = Self.promptOptions(for: promptCategory)[option].prompt
          case .weather:
            weather = Self.promptOptions(for: promptCategory)[option].prompt
          case .activities:
            activities = Self.promptOptions(for: promptCategory)[option].prompt
          }
        }
      }
    }
    
    guard let distance = distance,
          let period = period,
          let budget = budget,
          let weather = weather,
          let activities = activities,
          let city = city else {
      return ""
    }
    return "Suggest a \(budget) travel destination for \(period) that is \(distance) \(city) where I can \(activities) and which has \(weather) weather."
  }
  
  static private func promptOptions(for category: PromptCategory) -> [(option: String, prompt: String)] {
    switch category {
    case .distance:
      return [(option: "nearby", prompt: "close to"),
              (option: "not too far", prompt: "flight distance from"),
              (option: "far", prompt: "really far from")]
    case .period:
      return [(option: "spring", prompt: "spring"),
              (option: "summer", prompt: "summer"),
              (option: "autumn", prompt: "autumn"),
              (option: "winter", prompt: "winter")]
    case .budget:
      return [(option: "tight", prompt: "cheap"),
              (option: "mid-range", prompt: "average priced"),
              (option: "no limit", prompt: "luxurious")]
    case .weather:
      return [(option: "cold", prompt: "cool"),
              (option: "warm", prompt: "warm")]
    case .activities:
      return [(option: "relax in the mountains", prompt: "be in the mountains"),
              (option: "feal the breeze of the sea", prompt: "walk on the beach"),
              (option: "explore a city", prompt: "explore a city"),
              (option: "walk in nature", prompt: "be close to nature"),
              (option: "see wildlife", prompt: "see wildlife")]
    }
  }
}
