//
//  Navigation.swift
//  DestiAI
//
//  Created by Lorand Ignat on 19.04.2023.
//

import SwiftUI

struct SplitView: View {
  
  @State var columnVisibility = NavigationSplitViewVisibility.doubleColumn
  @State private var showingAlert = false
  
  // TODO: Refactor - VM factory/provider
  @StateObject private var navigationRouter = SplitViewNavigationRouter()
  @StateObject private var inputViewModel = InputViewModel()
  @StateObject private var searchViewModel = SearchViewModel()
  @StateObject private var suggestionViewModel = SuggestionViewModel()
  
  let searchView = SearchView()
  
  var body: some View {
    ZStack {
      NavigationSplitView(columnVisibility: $columnVisibility) {
        ZStack {
          SidebarView()
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .automatic)
#else
            .toolbarBackground(Color.primaryMedium.opacity(0), for: .automatic)
#endif
            .background(Color.primaryMedium)
            .gesture(
              DragGesture()
                .onEnded { value in
                  let delta = value.translation.width
                  let sensitivity: CGFloat = 100
                  if delta < -sensitivity  {
#if !os(macOS)
                navigationRouter.index = navigationRouter.lastIndex
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
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
      }
      .onChange(of: inputViewModel.searching) { newValue in
        if newValue {
          Task {
            let suggestion = await searchViewModel.search(for: inputViewModel.prompt)
            if let suggestion = suggestion {
              inputViewModel.resetValues()
              suggestionViewModel.add(suggestion: suggestion)
              navigationRouter.index = 1
            } else {
              showingAlert = true
            }
          }
        }
      }
      .alert(isPresented: $showingAlert) {
          Alert(title: Text("Error"),
                message: Text("Couldn't find a suggested location. Please try again later!"),
                dismissButton: .default(Text("Okay")))
      }
      .navigationSplitViewStyle(.balanced)
      .navigationTitle("")
      .tint(Color.contrast)
      .environmentObject(navigationRouter)
      .environmentObject(suggestionViewModel)
      .environmentObject(inputViewModel)
      
      SearchView()
        .environmentObject(searchViewModel)
    }
  }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
    SplitView()
  }
}
