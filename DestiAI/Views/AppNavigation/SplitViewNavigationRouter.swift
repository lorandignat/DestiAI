//
//  NavigationStateManager.swift
//  DestiAI
//
//  Created by Lorand Ignat on 20.04.2023.
//

import SwiftUI

// TODO: Refactor - Create generic superclass and modify the router to build root views (see SuggestionStackNavigationRouter)

class SplitViewNavigationRouter: ObservableObject {
  
  @Published var lastIndex: Int = 0
  @Published var index: Int? = 0 {
    didSet {
      if let index {
        lastIndex = index
      }
    }
  }
}
