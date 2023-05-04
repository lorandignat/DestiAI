//
//  InputView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 18.04.2023.
//

import Foundation

import SwiftUI

struct PromptView: View {
  
  @EnvironmentObject var inputViewModel: InputViewModel
  
  // Animation
  @State private var inputCompletedAnimation = false
  
#if !os(macOS)
  @Environment(\.verticalSizeClass) private var verticalSizeClass
#endif
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        VStack {
          Spacer()
            .frame(maxHeight: geometry.size.height / 6)
          ZStack {
            VStack {
              HStack {
                Image(systemName: "quote.opening")
                  .resizable()
                  .scaledToFit()
                  .foregroundColor(Color.light)
                  .frame(width: max(geometry.size.height, geometry.size.width) / 6, height: max(geometry.size.height, geometry.size.width) / 6)
                Spacer()
              }
              Spacer()
            }.padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
            VStack {
              Spacer()
              HStack {
                Spacer()
                Image(systemName: "quote.closing")
                  .resizable()
                  .scaledToFit()
                  .foregroundColor(Color.light)
                  .frame(width: max(geometry.size.height, geometry.size.width) / 6, height: max(geometry.size.height, geometry.size.width) / 6)
              }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
            Text(inputViewModel.prompt)
              .padding(EdgeInsets(top: 0, leading: geometry.size.width * 0.1, bottom: 0, trailing: geometry.size.width * 0.1))
              .font(Font.custom("HelveticaNeue", size: 24))
              .foregroundColor(.contrast)
              .multilineTextAlignment(.center)
          }.frame(maxHeight: geometry.size.height / 3)
          Button(action: {
            inputViewModel.searching.toggle()
          }) {
            Text("looks good")
              .fontWeight(inputCompletedAnimation ? .bold : .regular)
              .font(Font.custom("HelveticaNeue", size: 24))
              .foregroundColor(.contrast)
          }
          .buttonStyle(.plain)
          .frame(maxHeight: .infinity)
          .onChange(of: inputViewModel.searching) { _ in
            withAnimation(Animation.easeInOut(duration: 0.1)) {
              inputCompletedAnimation = true
            }
          }
          Spacer()
            .frame(maxHeight: geometry.size.height / 6)
        }
        .frame(maxWidth: .infinity)
      }
    }
  }
}

struct PromptView_Previews: PreviewProvider {
  static var previews: some View {
    
    let inputViewModel = InputViewModel()
    let _ = inputViewModel.select(option: 0, for: 0)
    let _ = inputViewModel.select(option: 0, for: 1)
    let _ = inputViewModel.select(option: 0, for: 2)
    let _ = inputViewModel.select(option: 0, for: 3)
    let _ = inputViewModel.select(option: 0, for: 4)
    
    PromptView()
      .environmentObject(inputViewModel)
  }
}
