//
//  SearchViewModel.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import Foundation

class SearchViewModel: ObservableObject {
  
  @Published private(set) var searching = false
  
  // Services
  // TODO: Refactor - service factory/provider
  private let suggestionService: SuggestionService = ChatGPTService()
  private let imageService: ImageService = UnsplashImageService()
  
  func search(for prompt: String) async -> Suggestion? {
    DispatchQueue.main.async {
      self.searching = true
    }
    let startTimestamp = Date().timeIntervalSince1970
    
    let suggestion = await suggestionService.requestSuggestion(for: prompt)
    guard var suggestion else {
      self.finishSearch(startedAt: startTimestamp)
      return nil
    }
    
    let images = await self.imageService.search(for: suggestion.location)
    
    suggestion.images = images
    
    self.finishSearch(startedAt: startTimestamp)
    
    return suggestion
  }
  
  func finishSearch(startedAt startTimestamp: TimeInterval) {
    let finishTimestamp = Date().timeIntervalSince1970
    if finishTimestamp - startTimestamp < 1000 {
      DispatchQueue.main.asyncAfter(deadline: .now() + (1000 - (finishTimestamp - startTimestamp)) / 1000) {
        self.searching = false
      }
    } else {
      DispatchQueue.main.async {
        self.searching = false
      }
    }
  }
}
