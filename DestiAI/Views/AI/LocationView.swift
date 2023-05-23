//
//  MapView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 21.04.2023.
//

import SwiftUI
import MapKit

struct LocationView: View {
  
  @EnvironmentObject var inputViewModel: InputViewModel
  
  // TODO: Refactor - VM factory/provider
  @StateObject var locationViewModel = LocationViewModel()
  
  // Hardcoded as the second view after welcome view
  private static let currentPageIndex = 1
  
  // Animation
  @State private var pageCompletedAnimation = currentPageIndex
  
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
        
        Text("Is \(locationViewModel.city) your base location?")
          .padding(EdgeInsets(top: 0, leading: geometry.size.width * 0.1, bottom: 0, trailing: geometry.size.width * 0.1))
          .font(Font.custom("HelveticaNeue-Bold", size: 34))
          .minimumScaleFactor(0.75)
          .foregroundColor(.contrast)
          .frame(maxHeight: geometry.size.height / 3)
          .multilineTextAlignment(.center)
          .frame(maxHeight: textHeight)
          .onChange(of: locationViewModel.city) { newValue in
            inputViewModel.clearSelection()
          }
        
        VStack {
          Spacer()
            .frame(minHeight: 8, maxHeight: 48)
          Button(action: {
            locationViewModel.pickerIsPresented.toggle()
          }) {
            Text("no")
              .fontWeight(.regular)
              .font(Font.custom("HelveticaNeue", size: 24))
              .foregroundColor(.contrast)
          }
          .sheet(isPresented: $locationViewModel.pickerIsPresented) {
            LocationPickerView()
              .environmentObject(locationViewModel)
#if os(macOS)
              .frame(width: 800, height: 600)
#endif
          }
          .buttonStyle(.plain)
          
          Spacer()
            .frame(minHeight: 8, maxHeight: 48)
          Button(action: {
            inputViewModel.city = locationViewModel.city
            inputViewModel.currentPage += 1
          }) {
            Text("yes")
              .fontWeight(pageCompletedAnimation > Self.currentPageIndex && inputViewModel.city == locationViewModel.city ? .bold : .regular)
              .font(Font.custom("HelveticaNeue", size: 24))
              .foregroundColor(.contrast)
              .onChange(of: inputViewModel.maxPage) { newValue in
                if inputViewModel.maxPage >= Self.currentPageIndex {
                  locationViewModel.stopSearchingForInitialLocation()
                }
                withAnimation(Animation.easeInOut(duration: 0.1)) {
                  pageCompletedAnimation = newValue
                }
              }
              .onAppear {
                pageCompletedAnimation = inputViewModel.maxPage
              }
          }
          .buttonStyle(.plain)
        }
        .frame(maxHeight: .infinity)
        
        Spacer()
          .frame(maxHeight: .infinity)
      }
      .frame(maxWidth: .infinity)
    }
  }
}

struct LocationView_Previews: PreviewProvider {
  static var previews: some View {
    LocationView()
      .environmentObject(InputViewModel())
  }
}
