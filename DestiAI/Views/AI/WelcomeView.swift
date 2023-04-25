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

  // Hardcoded as the first view
  private static let currentPageIndex = 0
  
  // Animation
  @State private var pagesCompletedAnimation = currentPageIndex
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        
        Spacer()
          .frame(maxHeight: geometry.size.height / 12)
        
        Text("Hi, I'm DestiAI!\n\nAn AI that can suggest travel destinations.")
          .padding(EdgeInsets(top: 0, leading: geometry.size.width * 0.1, bottom: 0, trailing: geometry.size.width * 0.1))
          .font(Font.custom("HelveticaNeue-Bold", size: 34))
          .minimumScaleFactor(0.75)
          .foregroundColor(.contrast)
          .frame(maxHeight: geometry.size.height / 3)
          .multilineTextAlignment(.center)
        
        Button(action: {
          inputViewModel.currentPage += 1
        }) {
          Text("let's get started")
            .fontWeight(pagesCompletedAnimation > Self.currentPageIndex ? .bold : .regular)
            .font(Font.custom("HelveticaNeue", size: 24))
            .foregroundColor(.contrast)
            .onChange(of: inputViewModel.maxPage) { newValue in
              withAnimation(Animation.easeInOut(duration: 0.1)) {
                pagesCompletedAnimation = newValue
              }
            }
            .onAppear() {
              pagesCompletedAnimation = inputViewModel.maxPage
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxHeight: .infinity)
        
        Spacer()
          .frame(maxHeight: geometry.size.height / 6)
      }
      .frame(maxWidth: .infinity)
    }
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView()
      .environmentObject(InputViewModel())
  }
}
