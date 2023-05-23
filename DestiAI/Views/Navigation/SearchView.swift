//
//  SearchingView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 02.05.2023.
//

import SwiftUI

struct SearchView: View {
  
  @EnvironmentObject var searchViewModel: SearchViewModel
  
  // Animation
  @State private var shouldShowCloudsAnimation = false
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Rectangle()
          .fill(Color.light)
          .ignoresSafeArea()
          .frame(width: geometry.size.width, height: geometry.size.height / 2)
          .position(x: geometry.size.width / 2, y: shouldShowCloudsAnimation ? (geometry.size.height - (geometry.size.height / 3)) / 4 : -geometry.size.height - (geometry.size.height / 3) )
        Image(systemName: "cloud.fill")
          .resizable()
          .scaledToFit()
          .foregroundColor(Color.light)
          .rotationEffect(Angle(degrees: 180))
          .frame(width: geometry.size.width, height: geometry.size.height)
          .position(x: geometry.size.width / 4, y: shouldShowCloudsAnimation ? geometry.size.height / 2 : -geometry.size.height)
        Image(systemName: "cloud.fill")
          .resizable()
          .scaledToFit()
          .foregroundColor(Color.light)
          .rotationEffect(Angle(degrees: 180))
          .frame(width: geometry.size.width, height: geometry.size.height)
          .position(x: geometry.size.width - geometry.size.width / 4, y: shouldShowCloudsAnimation ? geometry.size.height / 2 : -geometry.size.height)
      }
      
      ZStack {
        Image(systemName: "cloud.fill")
          .resizable()
          .scaledToFit()
          .foregroundStyle(Color.light)
          .frame(width: geometry.size.width, height: geometry.size.height)
          .position(x:  geometry.size.width / 4, y: shouldShowCloudsAnimation ? geometry.size.height - geometry.size.height / 2 :  geometry.size.height + geometry.size.height)
        Image(systemName: "cloud.fill")
          .resizable()
          .scaledToFit()
          .foregroundStyle(Color.light)
          .frame(width: geometry.size.width, height: geometry.size.height)
          .position(x: geometry.size.width - geometry.size.width / 4, y: shouldShowCloudsAnimation ? geometry.size.height - geometry.size.height / 2 :  geometry.size.height + geometry.size.height)
        Rectangle()
          .fill(Color.light)
          .ignoresSafeArea()
          .frame(width: geometry.size.width, height: geometry.size.height / 2)
          .position(x: geometry.size.width / 2, y: shouldShowCloudsAnimation ? geometry.size.height - geometry.size.height / 2 +  (geometry.size.height / 3): geometry.size.height + geometry.size.height + (geometry.size.height / 3))
      }
      
    }.onChange(of: searchViewModel.searching) { newValue in
      withAnimation(Animation.easeInOut.speed(0.4)) {
        shouldShowCloudsAnimation = newValue
      }
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView()
  }
}
