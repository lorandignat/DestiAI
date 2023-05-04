//
//  NavigationStateManager.swift
//  DestiAI
//
//  Created by Lorand Ignat on 20.04.2023.
//

import Foundation

class NavigationViewModel: ObservableObject {
  
  @Published private(set) var lastItemSelected: Int = 0
  @Published var selectedItem: Int? = 0 {
    didSet {
      if let selectedItem {
        lastItemSelected = selectedItem
      }
    }
  }
}
