//
//  Navigation.swift
//  DestiAI
//
//  Created by Lorand Ignat on 19.04.2023.
//

import SwiftUI

struct NavigationView: View {
  
  @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
  
  @StateObject private var navigationViewModel = NavigationViewModel()
  @StateObject private var inputViewModel = InputViewModel()
  @StateObject private var searchViewModel = SearchViewModel()
  @StateObject private var suggestionViewModel = SuggestionViewModel()
  
  let searchView = SearchView()
  
  var body: some View {
    ZStack {
      NavigationSplitView(columnVisibility: $columnVisibility) {
        ZStack {
          SidebarView()
            .background(Color.primaryMedium)
            .simultaneousGesture(
              DragGesture()
                .onEnded { value in
                  let delta = value.translation.width
                  let sensitivity: CGFloat = 100
                  if delta < -sensitivity  {
#if !os(macOS)
                    if UIDevice.current.userInterfaceIdiom == .phone {
                      navigationViewModel.selectedItem = navigationViewModel.lastItemSelected
                    }
#endif
                  }
                })
        }
#if os(macOS)
        .navigationSplitViewColumnWidth(min: 250, ideal: 250, max: 350)
#endif
      } detail: {
        ZStack {
          ContentView()
            .navigationBarBackButtonHidden(true)
        }
      }
      .onChange(of: inputViewModel.searching) { newValue in
        if newValue {
          searchViewModel.search(for: inputViewModel.prompt) { suggestion in
            if let suggestion = suggestion {
              inputViewModel.resetValues()
              suggestionViewModel.add(suggestion: suggestion)
              navigationViewModel.selectedItem = 1
            }
          }
        }
      }
      .accentColor(Color.contrast)
      .tint(Color.contrast)
      .navigationSplitViewStyle(.balanced)
#if os(macOS)
      .toolbarBackground(Color.primaryMedium, for: .automatic)
      .navigationTitle("")
#endif
      .environmentObject(navigationViewModel)
      .environmentObject(suggestionViewModel)
      .environmentObject(inputViewModel)
      
      SearchView()
        .environmentObject(searchViewModel)
    }
  }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView()
  }
}
