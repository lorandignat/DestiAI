//
//  ContentView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 20.04.2023.
//

import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var navigationViewModel: NavigationViewModel
  @EnvironmentObject var inputViewModel: InputViewModel
  @EnvironmentObject var suggestionViewModel: SuggestionViewModel
  
  var body: some View {
    ZStack {
      Color.primaryLight.ignoresSafeArea()
      
      if let selectedItem = navigationViewModel.selectedItem {
        if selectedItem == 0 {
          InputView()
            .environmentObject(inputViewModel)
        } else {
          SuggestionView(suggestion: suggestionViewModel.suggestions[selectedItem - 1])
        }
      }
      
#if !os(macOS)
      if UIDevice.current.userInterfaceIdiom == .phone {
        Button(action: {
          navigationViewModel.selectedItem = nil
        }) {
          Image(systemName: "sidebar.left")
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        }
        .frame(width: 35, height: 35)
        .position(CGPoint(x: 30, y: 30))
        .foregroundColor(.contrast)
      }
#endif
    }.simultaneousGesture(
      DragGesture()
        .onEnded { value in
          let delta = value.translation.width
          let sensitivity: CGFloat = 100
          if delta > sensitivity {
#if !os(macOS)
            if UIDevice.current.userInterfaceIdiom == .phone {
              navigationViewModel.selectedItem = nil
            }
#endif
          }
        })
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(NavigationViewModel())
      .environmentObject(InputViewModel())
  }
}
