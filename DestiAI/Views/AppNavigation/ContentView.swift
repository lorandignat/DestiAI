//
//  ContentView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 20.04.2023.
//

import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var navigationRouter: SplitViewNavigationRouter
  @EnvironmentObject var inputViewModel: InputViewModel
  @EnvironmentObject var suggestionViewModel: SuggestionViewModel
  
  var body: some View {
    ZStack {
      Color.primaryLight.ignoresSafeArea()
      if let selectedItem = navigationRouter.index {
        if selectedItem == 0 {
          InputView()
            .environmentObject(inputViewModel)
        } else {
          SuggestionView(suggestion: suggestionViewModel.suggestions[selectedItem - 1])
        }
      }
    }.simultaneousGesture(
      DragGesture()
        .onEnded { value in
          let delta = value.translation.width
          let sensitivity: CGFloat = 100
          if delta > sensitivity {
#if !os(macOS)
            if UIDevice.current.userInterfaceIdiom == .phone {
              navigationRouter.index = nil
            }
#endif
          }
        })
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(SplitViewNavigationRouter())
      .environmentObject(InputViewModel())
  }
}
