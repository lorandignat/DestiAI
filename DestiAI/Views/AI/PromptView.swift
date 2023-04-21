//
//  InputView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 18.04.2023.
//

import Foundation

import SwiftUI

struct PromptView: View {
  
  var onSearch: (() -> Void)? = nil
  @State private var isSearching = false
  
  @EnvironmentObject var inputViewModel: InputViewModel
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
          Button(action: {
            withAnimation() {
              isSearching = true
            }
            onSearch?()
          }) {
            Text(inputViewModel.prompt)
              .fontWeight(isSearching ? .bold : .regular)
              .font(Font.custom("HelveticaNeue", size: 24))
              .foregroundColor(.contrast)
              .padding(EdgeInsets(top: 0, leading: geometry.size.width * 0.1, bottom: 0, trailing: geometry.size.width * 0.1))
              .multilineTextAlignment(.center)
          }
          .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2)
          .buttonStyle(PlainButtonStyle())
        
        Spacer()
      }
    }
  }
}

struct PromptView_Previews: PreviewProvider {
  static var previews: some View {
    PromptView()
      .environmentObject(InputViewModel())
  }
}
