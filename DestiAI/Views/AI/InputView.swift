//
//  ContentView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 18.04.2023.
//

import SwiftUI

struct InputView: View {
  
  @EnvironmentObject var inputViewModel: InputViewModel
  
  // Animation
  @State private var isScrollAnimation = false
  @State private var scrollUpOpacityAnimation = 0.0
  @State private var scrollDownOpacityAnimation = 0.0
  @State private var pagesScrolledAnimation = 0

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.primaryLight.ignoresSafeArea()
        ScrollView(.vertical, showsIndicators: true) {
          VStack(spacing: 0) {
            WelcomeView()
              .frame(width: geometry.size.width, height: geometry.size.height)
              .environmentObject(inputViewModel)
            LocationView()
              .frame(width: geometry.size.width, height: geometry.size.height)
              .environmentObject(inputViewModel)
            ForEach(0..<inputViewModel.numberOfQuestions(), id: \.self) { index in
              ZStack {
                Rectangle()
                  .fill(Color.primaryLight)
                  .frame(height: geometry.size.height)
                QuestionsView(questionIndex: index)
                  .environmentObject(inputViewModel)
                  .frame(width: geometry.size.width, height: geometry.size.height)
              }
            }
            PromptView()
              .frame(width: geometry.size.width, height: geometry.size.height)
              .environmentObject(inputViewModel)
          }
        }
        .content.offset(y: -geometry.size.height * CGFloat(pagesScrolledAnimation))
        .frame(maxHeight: .infinity)
        .scrollContentBackground(.hidden)
      }.simultaneousGesture(
        DragGesture()
          .onEnded { value in
            let delta = value.translation.height
            let sensitivity: CGFloat = 100
            let totalPages = inputViewModel.numberOfQuestions() + inputViewModel.numberOfExtraPages
            if delta < -sensitivity &&
                inputViewModel.currentPage < totalPages - 1 &&
                inputViewModel.currentPage < inputViewModel.maxPage {
              isScrollAnimation = true
              inputViewModel.currentPage += 1
            } else if delta > sensitivity && inputViewModel.currentPage > 0 {
              isScrollAnimation = true
              inputViewModel.currentPage -= 1
            }
          }
      )
      
      pageIndex(for: geometry)
      scrollLabels(for: geometry)
    }
    .onChange(of: inputViewModel.currentPage) { newValue in
      animateView(for: newValue)
    }
    .onChange(of: inputViewModel.maxPage) { _ in
      animateView(for: inputViewModel.currentPage)
    }
    .onAppear {
      pagesScrolledAnimation = inputViewModel.currentPage
      scrollUpOpacityAnimation = inputViewModel.currentPage > 0 ? 1 : 0
      scrollDownOpacityAnimation = inputViewModel.currentPage < inputViewModel.maxPage ? 1 : 0
    }
  }
  
  private func pageIndex(for geometry: GeometryProxy) -> some View {
    VStack {
      ForEach(0..<inputViewModel.numberOfQuestions() + inputViewModel.numberOfExtraPages, id: \.self) { index in
        HStack {
          Spacer()
          ZStack {
            HStack{
            Text("\(index + 1)")
              .foregroundColor(inputViewModel.currentPage == index ? Color.contrast :
                                index <= inputViewModel.maxPage ? Color.primaryDark : Color.primaryMedium)
              .font(Font.custom("HelveticaNeue", size: 12))
            Rectangle()
              .fill(inputViewModel.currentPage == index ? Color.contrast :
                      index <= inputViewModel.maxPage ? Color.primaryDark : Color.primaryMedium)
              .frame(width: 2)
              .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            }
          }
          .clipShape(Rectangle())
          .contentShape(Rectangle())
          .onTapGesture {
            if index <= inputViewModel.maxPage {
              inputViewModel.currentPage = index
            }
          }
        }
      }
    }
    .padding(EdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 4))
    .frame(height: geometry.size.height)
  }
  
  private func scrollLabels(for geometry: GeometryProxy) -> some View {
    VStack {
      Text("↑ scroll up ↑")
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        .font(Font.custom("HelveticaNeue", size: 12))
        .foregroundColor(.primaryMedium)
        .frame(width: geometry.size.width)
        .multilineTextAlignment(.center)
        .transition(.asymmetric(insertion: .scale, removal: .scale))
        .opacity(scrollUpOpacityAnimation)
      Spacer()
      Text("↓ scroll down ↓")
        .font(Font.custom("HelveticaNeue", size: 12))
        .foregroundColor(.primaryMedium)
        .frame(width: geometry.size.width)
        .multilineTextAlignment(.center)
        .transition(.asymmetric(insertion: .scale, removal: .scale))
        .opacity(scrollDownOpacityAnimation)
    }
  }
  
  private func animateView(for currentPage: Int) {
    let animate = {
      withAnimation(Animation.easeInOut(duration: 0.5)) {
        pagesScrolledAnimation = currentPage
        scrollUpOpacityAnimation = currentPage > 0 ? 1 : 0
        scrollDownOpacityAnimation = currentPage < inputViewModel.maxPage ? 1 : 0
      }
    }
    if !isScrollAnimation {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
        animate()
      }
    } else {
      animate()
    }
    isScrollAnimation = false
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView()
      .environmentObject(InputViewModel())
  }
}
