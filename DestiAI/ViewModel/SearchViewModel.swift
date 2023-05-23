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
  
  func search(for prompt: String, completion: @escaping (_ suggestion: Suggestion?) -> ()) {
   
    searching = true
    let startTimestamp = Date().timeIntervalSince1970
    suggestionService.requestSuggestion(for: prompt) { [weak self] suggestion in

      guard let self else { return }
      guard let suggestion else {
        self.finishSearch(startedAt: startTimestamp, with: nil, completion: completion)
        return
      }

      Task {
        let images = await self.imageService.search(for: suggestion.location)
        
        var mutableSuggestion = suggestion
        mutableSuggestion.images = images
        
        self.finishSearch(startedAt: startTimestamp, with: mutableSuggestion, completion: completion)
      }
    }
  }
  
  func finishSearch(startedAt startTimestamp: TimeInterval,
                    with suggestion: Suggestion?,
                    completion: @escaping (_ suggestion: Suggestion?) -> ()) {
    let finishTimestamp = Date().timeIntervalSince1970
    if finishTimestamp - startTimestamp < 1000 {
      DispatchQueue.main.asyncAfter(deadline: .now() + (1000 - (finishTimestamp - startTimestamp)) / 1000) {
        self.searching = false
        completion(suggestion)
      }
    } else {
      DispatchQueue.main.async {
        self.searching = false
        completion(suggestion)
      }
    }
  }
}
