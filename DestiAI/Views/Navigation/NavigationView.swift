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
  
  var body: some View {
    NavigationSplitView(columnVisibility: $columnVisibility) {
      ZStack {
        SidebarView()
          .background(Color.primaryMedium)
          .gesture(
            DragGesture()
              .onEnded { value in
                let delta = value.translation.width
                let sensitivity: CGFloat = 100
                if delta < -sensitivity  {
#if !os(macOS)
                  if UIDevice.current.userInterfaceIdiom == .phone {
                    navigationViewModel.selectedItem = 0
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
    .accentColor(Color.contrast)
    .tint(Color.contrast)
    .navigationSplitViewStyle(.balanced)
#if os(macOS)
    .toolbarBackground(Color.primaryMedium, for: .automatic)
    .navigationTitle("")
#endif
    .environmentObject(navigationViewModel)
    .environmentObject(inputViewModel)
  }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView()
  }
}
