//
//  SuggestionView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import SwiftUI

struct SuggestionView: View {
  
  @StateObject private var navigationRouter: StackNavigationRouter
  
  init(suggestion: Suggestion) {
    _navigationRouter = StateObject(wrappedValue: SuggestionStackNavigationRouter(suggestion: suggestion))
  }
  
  var body: some View {
    GeometryReader { geometry in
      Color.primaryLight.ignoresSafeArea()
      ZStack {
        
        StackNavigationView()
          .environmentObject(navigationRouter)
        
// Note: This also work on iOS
//#if !os(macOS)
//        SuggestionStackView(navigationRouter: navigationRouter)
//          .ignoresSafeArea()
//#endif
        
        cloudsView(in: geometry)
        navigationButtonsView()
      }
    }
  }
  
  func cloudsView(in geometry: GeometryProxy) -> some View {
    ZStack {
      Image(systemName: "cloud.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
        .foregroundColor(.light)
        .ignoresSafeArea()
        .position(x: CGFloat(0 + Int.random(in: -10...10)), y: geometry.size.height)
      Image(systemName: "cloud.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
        .foregroundColor(.light)
        .ignoresSafeArea()
        .position(x: CGFloat(100 + Int.random(in: -10...10)), y: geometry.size.height)
      Image(systemName: "cloud.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
        .foregroundColor(.light)
        .ignoresSafeArea()
        .position(x: CGFloat(Int(geometry.size.width) - 100 + Int.random(in: -10...10)), y: geometry.size.height)
      Image(systemName: "cloud.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
        .foregroundColor(.light)
        .ignoresSafeArea()
        .position(x: CGFloat(Int(geometry.size.width) + Int.random(in: -10...10)), y: geometry.size.height)
    }
  }
  
  func navigationButtonsView() -> some View {
    VStack {
      Spacer()
      HStack {
        if navigationRouter.index > 0 {
          Button {
            withAnimation {
              if navigationRouter.index > 0 {
                navigationRouter.index -= 1
              }
            }
          } label: {
            Image(systemName: "arrow.left")
              .resizable()
              .scaledToFit()
              .frame(width: 32, height: 32)
              .foregroundColor(.contrast)
          }
          .buttonStyle(.plain)
        }
        Spacer()
        if navigationRouter.index < 2 {
          Button {
            withAnimation {
              if navigationRouter.index < 2 {
                  navigationRouter.index += 1
              }
            }
          } label: {
            Image(systemName: "arrow.right")
              .resizable()
              .scaledToFit()
              .frame(width: 32, height: 32)
              .foregroundColor(.contrast)
          }
          .buttonStyle(.plain)
        }
      }
#if os(macOS)
      .padding(EdgeInsets(top: 8, leading: 40, bottom: 16, trailing: 40))
#else
      .padding(EdgeInsets(top: 8, leading: 32, bottom: 0, trailing: 32))
#endif
    }
  }
}

struct SuggestionView_Previews: PreviewProvider {
  static var previews: some View {
    SuggestionView(suggestion: Suggestion(location: "Cluj Napoca, Romania", description: "Cluj-Napoca, a city in northwestern Romania, is the unofficial capital of the Transylvania region. It's home to universities, vibrant nightlife and landmarks dating to Saxon and Hungarian rule."))
  }
}
