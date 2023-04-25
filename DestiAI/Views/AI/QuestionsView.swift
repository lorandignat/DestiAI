//
//  InputView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 18.04.2023.
//

import Foundation

import SwiftUI

struct QuestionsView: View {
  
  var questionIndex: Int = 0
  
  @EnvironmentObject var inputViewModel: InputViewModel
  
  // Animation
  @State private var selectedIndexAnimation: Int?
  
#if !os(macOS)
  @Environment(\.verticalSizeClass) private var verticalSizeClass
#endif
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        
#if !os(macOS)
        let textHeight = verticalSizeClass == .regular ? geometry.size.height / 3 : geometry.size.height / 4
#else
        let textHeight = geometry.size.height / 3
#endif
        
        Spacer()
          .frame(maxHeight: geometry.size.height / 12)
        
        Text(inputViewModel.question(for: questionIndex))
          .padding(EdgeInsets(top: 0, leading: geometry.size.width * 0.1, bottom: 0, trailing: geometry.size.width * 0.1))
          .font(Font.custom("HelveticaNeue-Bold", size: 34))
          .minimumScaleFactor(0.75)
          .foregroundColor(.contrast)
          .multilineTextAlignment(.center)
          .frame(maxHeight: textHeight)
        
        VStack {
          ForEach(0..<inputViewModel.numberOfOptions(for: questionIndex), id: \.self) { index in
            Spacer()
              .frame(minHeight: 8, maxHeight: 48)
            Button(action: {
              inputViewModel.select(option: index, for: questionIndex)
            }) {
              Text(inputViewModel.options(for: questionIndex)[index])
                .fontWeight(selectedIndexAnimation == index ? .bold : .regular)
                .font(Font.custom("HelveticaNeue", size: 24))
                .foregroundColor(.contrast)
                .onChange(of: inputViewModel.currentOptionsSelected) { newValue in
                  withAnimation(Animation.easeInOut(duration: 0.1)) {
                    selectedIndexAnimation = newValue[questionIndex]
                  }
                }
                .onAppear {
                  selectedIndexAnimation = inputViewModel.currentOptionsSelected[questionIndex]
                }
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
        .frame(maxHeight: .infinity)
        
        Spacer()
          .frame(maxHeight: .infinity)
      }
      .frame(maxWidth: .infinity)
    }
  }
}

struct QuestionsView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionsView()
      .environmentObject(InputViewModel())
  }
}
