//
//  StackNavigationRouter.swift
//  DestiAI
//
//  Created by Lorand Ignat on 30.05.2023.
//

import SwiftUI

class StackNavigationRouter: ObservableObject {
  
  @Published var index: Int = 0 {
    willSet {
      if index < newValue {
        _shouldPush = true
      } else if index > newValue {
        _shouldPop = true
      }
    }
  }
  
  private var _shouldPush = false
  private var _shouldPop = false
  var shouldPush: Bool {
    get {
      defer {
        _shouldPush = false
      }
      return _shouldPush
    }
  }
  var shouldPop: Bool {
    get {
      defer {
        _shouldPop = false
      }
      return _shouldPop
    }
  }
  
  @ViewBuilder final func makeBody() -> any View {
      createView()
  }
  
  func createView() -> any View {
    return EmptyView()
  }
}
