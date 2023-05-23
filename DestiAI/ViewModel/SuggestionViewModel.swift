//
//  SuggestionViewModel.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import Foundation

class SuggestionViewModel: ObservableObject {
  
  @Published private(set) var suggestions = (try? PropertyListDecoder().decode([Suggestion].self, from: UserDefaults.standard.data(forKey: "destiAi.suggestionsViewModel.suggestion") ?? Data())) ?? [Suggestion]()
  
  func add(suggestion: Suggestion) {
    suggestions.insert(suggestion, at: 0)
    
    // TODO: Extract persistance logic, switch to CoreData
    if let data = try? PropertyListEncoder().encode(suggestions) {
      UserDefaults.standard.set(data, forKey: "destiAi.suggestionsViewModel.suggestion")
    }
  }
  
  func remove(at index: Int) {
    
    for index in 0..<suggestions.count {
      if let images = suggestions[index].images {
        for index in 0..<images.count {
          do {
            try FileManager.default.removeItem(at: images[index])
          } catch {
            print(error.localizedDescription)
          }
        }
      }
    }
    
    suggestions.remove(at: index)
    
    // TODO: Extract persistance logic, switch to CoreData
    if let data = try? PropertyListEncoder().encode(suggestions) {
      UserDefaults.standard.set(data, forKey: "destiAi.suggestionsViewModel.suggestion")
    }
  }
}
