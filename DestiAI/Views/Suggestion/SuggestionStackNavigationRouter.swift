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
      return SuggestionTitleView(location: suggestion.location, description: suggestion.description, image: suggestion.images?[safe: 0])
    case 1:
      return SuggestionActivitiesView(activities: suggestion.activities!, images: [suggestion.images?[safe: 1], suggestion.images?[safe: 2], suggestion.images?[safe: 3]])
    case 2:
      return SuggestionAccomodationView(hotels: suggestion.hotels!, images: [suggestion.images?[safe: 4], suggestion.images?[safe: 5]])
    default:
      return EmptyView()
    }
  }
}
 
                                                                                   
                                      
                                                                                   
