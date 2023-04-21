//
//  InputView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 18.04.2023.
//

import Foundation

import SwiftUI

struct WelcomeView: View {
  
  @EnvironmentObject var inputViewModel: InputViewModel
  
  @State private var maxPageAnimation = 0
  
#if !os(macOS)
  @Environment(\.verticalSizeClass) private var verticalSizeClass
#endif
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        
        // TOP SPACE
        
#if !os(macOS)
        let spacerMaxHeightTop = verticalSizeClass == .regular ? geometry.size.height / 6 : geometry.size.height / 12
#else
        let spacerMaxHeightTop = geometry.size.height / 6
#endif
        
        Spacer()
          .frame(maxWidth: .infinity, maxHeight: spacerMaxHeightTop)
        
        // TITLE AND BUTTON
        
        VStack(spacing: 16) {
          
#if !os(macOS)
          let textMinHeight = verticalSizeClass == .regular ? geometry.size.height / 12 : geometry.size.height / 4
#else
          let textMinHeight = geometry.size.height / 12
#endif
          
          Text("Hi, I'm DestiAI! \n An AI that can suggest travel destinations.")
            .padding(EdgeInsets(top: 0, leading: geometry.size.width * 0.1, bottom: 0, trailing: geometry.size.width * 0.1))
            .font(Font.custom("HelveticaNeue-Bold", size: 34))
            .minimumScaleFactor(0.75)
            .foregroundColor(.contrast)
            .frame(minHeight: textMinHeight)
            .multilineTextAlignment(.center)
          
          Spacer()
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 12)
 
          Button(action: {
            inputViewModel.currentPage += 1
          }) {
            Text("let's get started")
              .fontWeight(maxPageAnimation > 0 ? .bold : .regular)
              .font(Font.custom("HelveticaNeue", size: 24))
              .foregroundColor(.contrast)
              .onChange(of: inputViewModel.maxPage) { newValue in
                withAnimation(Animation.easeInOut(duration: 0.1)) {
                  maxPageAnimation = newValue
                }
              }
              .onAppear() {
                maxPageAnimation = inputViewModel.maxPage
              }
          }
          .buttonStyle(PlainButtonStyle())
          .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2)
        }
        
        // BOTTOM SPACE
        
#if !os(macOS)
        let spacerMaxHeightBottom = verticalSizeClass == .regular ? geometry.size.height / 3 : geometry.size.height / 12
#else
        let spacerMaxHeightBottom = geometry.size.height / 3
#endif
        
        Spacer()
          .frame(maxWidth: .infinity,
                 maxHeight:spacerMaxHeightBottom)
      }
    }
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView()
  }
}
