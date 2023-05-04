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
    ZStack {
      Color.primaryLight.ignoresSafeArea()
      VStack {
        Text(suggestion.location)
        Text(suggestion.description)
        Text(suggestion.weather)
      }
    }
  }
}

struct SuggestionView_Previews: PreviewProvider {
  static var previews: some View {
    SuggestionView(suggestion: Suggestion(location: "", description: "", weather: "", activities: [:], hotels: [:]))
  }
}

