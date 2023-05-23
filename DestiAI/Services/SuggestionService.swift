//
//  SuggestionService.swift
//  DestiAI
//
//  Created by Lorand Ignat on 16.05.2023.
//

import Foundation

protocol SuggestionService {
  func requestSuggestion(for prompt: String,
                         completion: @escaping (_ suggestion: Suggestion?) -> ())
}
