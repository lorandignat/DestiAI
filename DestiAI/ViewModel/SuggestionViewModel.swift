//
//  SuggestionViewModel.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import Foundation

class SuggestionViewModel: ObservableObject {
  
  @Published private(set) var suggestions = [Suggestion]()
  
  func add(suggestion: Suggestion) {
    suggestions.insert(suggestion, at: 0)
  }
  
  func remove(at index: Int) {
    suggestions.remove(at: index)
  }
}
