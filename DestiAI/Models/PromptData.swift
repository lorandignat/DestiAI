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
  
  static func prompt(for values: [Int: Int]) -> String {
    
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
          let activities = activities else {
      return ""
    }
    return "Suggest a \(budget) travel destination for \(period) that is \(distance) away from Cluj, Romania. Where I can \(activities). It should have \(weather) weather."
  }
  
  static private func promptOptions(for category: PromptCategory) -> [(option: String, prompt: String)] {
    switch category {
    case .distance:
      return [(option: "nearby", prompt: "a drive distance"),
              (option: "not too far", prompt: "a flight distance"),
              (option: "far", prompt: "really far")]
    case .period:
      return [(option: "spring", prompt: "spring"),
              (option: "summer", prompt: "summer"),
              (option: "autumn", prompt: "autumn"),
              (option: "winter", prompt: "winter")]
    case .budget:
      return [(option: "tight", prompt: "budget"),
              (option: "mid-range", prompt: "mid-range"),
              (option: "no limit", prompt: "luxury")]
    case .weather:
      return [(option: "cold", prompt: "cool"),
              (option: "warm", prompt: "warm")]
    case .activities:
      return [(option: "relax in the mountains", prompt: "be close to mountains"),
              (option: "feal the breeze of the sea", prompt: "be close to the sea"),
              (option: "explore a city", prompt: "explore a city"),
              (option: "walk in nature", prompt: "be close to nature"),
              (option: "see wildlife", prompt: "see wildlife")]
    }
  }
}
