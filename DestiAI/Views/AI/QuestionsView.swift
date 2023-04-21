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
  
  @State private var selectedIndexAnimation: Int?
  
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

        // TITLE AND BUTTONS
        
        VStack(spacing: 16) {

          // TITLE
          
#if !os(macOS)
          let textMinHeight = verticalSizeClass == .regular ? geometry.size.height / 12 : geometry.size.height / 4
#else
          let textMinHeight = geometry.size.height / 12
#endif
          
          Text(inputViewModel.question(for: questionIndex))
            .padding(EdgeInsets(top: 0, leading: geometry.size.width * 0.1, bottom: 0, trailing: geometry.size.width * 0.1))
            .font(Font.custom("HelveticaNeue-Bold", size: 34))
            .minimumScaleFactor(0.75)
            .foregroundColor(.contrast)
            .frame(minHeight: textMinHeight)
            .multilineTextAlignment(.center)
          
          // SPACE
          
          Spacer()
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 12)
          
          // BUTTONS
          
#if !os(macOS)
          let vstackSpacing = verticalSizeClass == .regular ? 48 : 16
#else
          let vstackSpacing = 48
#endif
          
          VStack(spacing: CGFloat(vstackSpacing)) {
            ForEach(0..<inputViewModel.numberOfOptions(for: questionIndex), id: \.self) { index in
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

struct QuestionsView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionsView()
  }
}
