//
//  SuggestionStackNavigationRouter.swift
//  DestiAI
//
//  Created by Lorand Ignat on 29.05.2023.
//

import SwiftUI

class SuggestionStackNavigationRouter: StackNavigationRouter {

  var suggestion: Suggestion
  
  init(suggestion: Suggestion) {
    self.suggestion = suggestion
  }
  
  override func createView() -> any View {
    switch index {
    case 0:
      return SuggestionTitleView(location: suggestion.location, description: suggestion.description, image: suggestion.images?.first)
    case 1:
      return SuggestionActivitiesView()
    default:
      return EmptyView()
    }
  }
}
