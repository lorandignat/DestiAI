//
//  SuggestionView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import SwiftUI

struct SuggestionView: View {
  
  var suggestion: Suggestion
  
  var body: some View {
    
    
#if !os(macOS)
    NavigationView {
      SuggestionTitleView(location: suggestion.location, description: suggestion.description, image: suggestion.images?.first)
        .navigationBarHidden(true)
    }
#else
    SuggestionTitleView(location: suggestion.location, description: suggestion.description, image: suggestion.images?.first)
#endif
  }
}

struct SuggestionView_Previews: PreviewProvider {
  static var previews: some View {
    SuggestionView(suggestion: Suggestion(location: "Cluj Napoca, Romania", description: "Cluj-Napoca, a city in northwestern Romania, is the unofficial capital of the Transylvania region. It's home to universities, vibrant nightlife and landmarks dating to Saxon and Hungarian rule."))
  }
}
