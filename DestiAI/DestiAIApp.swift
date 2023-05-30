//
//  DestiAIApp.swift
//  DestiAI
//
//  Created by Lorand Ignat on 18.04.2023.
//

import SwiftUI

@main
struct DestiAIApp: App {

  var body: some Scene {
    WindowGroup {
      ZStack {
        SplitView()
          .background(Color.primaryLight)
#if os(macOS)
          .frame(minWidth: 800, idealWidth: 960, minHeight: 600, idealHeight: 960)
#endif
      }
    }
#if os(macOS)
    .commands {
      SidebarCommands()
    }
#endif
  }
}
