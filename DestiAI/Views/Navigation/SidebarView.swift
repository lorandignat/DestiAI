//
//  Sidebar.swift
//  DestiAI
//
//  Created by Lorand Ignat on 20.04.2023.
//

import SwiftUI

struct SidebarView: View {
  
  @EnvironmentObject var navigationViewModel: NavigationViewModel
  
  var body: some View {
    ZStack {
      Color.primaryMedium.ignoresSafeArea()
      List(selection: $navigationViewModel.selectedItem) {
#if !os(macOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
          mainSectionItem
            .background(Color.contrast)
            .listRowBackground(Color.primaryMedium)
        } else {
          mainSectionItem
        }
#else
        mainSectionItem
#endif
      }
      .scrollContentBackground(.hidden)
    }
  }
  
  var mainSectionItem: some View {
    HStack {
      Spacer()
      Text("DestiAI")
#if os(macOS)
        .font(Font.custom("HelveticaNeue-Bold", size: 16))
#else
        .font(Font.custom("HelveticaNeue-Bold", size: 24))
#endif
        .foregroundColor(Color.primaryLight)
      Spacer()
    }
    .tag(0)
    .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
  }
}

struct SidebarView_Previews: PreviewProvider {
  static var previews: some View {
    SidebarView()
      .environmentObject(NavigationViewModel())
  }
}
