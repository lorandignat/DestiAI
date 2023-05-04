//
//  SearchViewModel.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import Foundation

class SearchViewModel: ObservableObject {
  
  @Published private(set) var searching = false
  
  private let service = ChatGPTService()
  
  func search(for prompt: String, completion: @escaping (_ suggestion: Suggestion?) -> ()) {
   
    searching = true
    let startTimestamp = Date().timeIntervalSince1970
    service.performRequest(for: prompt) { [weak self] suggestion in

      let finishTimestamp = Date().timeIntervalSince1970
      if finishTimestamp - startTimestamp < 1000 {
        DispatchQueue.main.asyncAfter(deadline: .now() + (1000 - (finishTimestamp - startTimestamp)) / 1000) {
          self?.searching = false
          completion(suggestion)
        }
      } else {
        DispatchQueue.main.async {
          self?.searching = false
          completion(suggestion)
        }
      }
    }
  }
}
