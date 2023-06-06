//
//  StackNavigationView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 30.05.2023.
//

import SwiftUI

struct StackNavigationView: View {
  
  @EnvironmentObject var navigationRouter: StackNavigationRouter

  @State private var view: AnyView?
  @State private var reverseAnimation = false
  
  var body: some View {
    VStack {
      if let view {
        if reverseAnimation {
          view
            .transition(.asymmetric(insertion: .move(edge: .leading),
                                    removal: .move(edge: .trailing)))
        } else {
          view
            .transition(.asymmetric(insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)))
        }
      }
    }
    .onAppear() {
      view = AnyView(navigationRouter.makeBody())
    }
    .onChange(of: navigationRouter.shouldPush) { newValue in
      if newValue {
        reverseAnimation = false
        withAnimation {
          view = AnyView(navigationRouter.makeBody())
        }
      }
    }
    .onChange(of: navigationRouter.shouldPop) { newValue in
      if newValue {
        reverseAnimation = true
        withAnimation {
          view = AnyView(navigationRouter.makeBody())
        }
      }
    }
  }
}
