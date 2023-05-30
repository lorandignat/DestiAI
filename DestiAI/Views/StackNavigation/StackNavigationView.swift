//
//  StackNavigationView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 30.05.2023.
//

import SwiftUI

struct StackNavigationView: View {
  
  @ObservedObject var navigationRouter: StackNavigationRouter
  
  private var views: [AnyView]
  
  init(navigationRouter: StackNavigationRouter) {
    _navigationRouter = ObservedObject(wrappedValue: navigationRouter)
    views = [AnyView(navigationRouter.makeBody())]
  }
  
  var body: some View {
    VStack {
      views.last
        .zIndex(-1)
        .transition(.move(edge: .leading))
    }
  }
  
  mutating func transition() {
    if navigationRouter.shouldPush {
      views.append(AnyView(navigationRouter.makeBody()))
    } else if navigationRouter.shouldPop {
      views.removeLast()
    }
  }
}
