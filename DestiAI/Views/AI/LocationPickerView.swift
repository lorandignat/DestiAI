//
//  MapView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 24.04.2023.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
  
  @EnvironmentObject var locationViewModel: LocationViewModel
  
  @State private var isLoadingAnimation = false
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        MapView(region: $locationViewModel.pickerRegion)
          .ignoresSafeArea()
          .onChange(of: locationViewModel.pickerRegion.center) { newValue in
            locationViewModel.pickerValuesChanged()
          }
        
        Image(systemName: "hand.point.down.fill")
          .resizable()
          .scaledToFill()
          .foregroundColor(Color.contrast)
          .frame(width: 32, height: 32)
          .position(CGPoint(x: geometry.size.width / 2 - 4, y: geometry.size.height / 2 - 16))
          .shadow(color: .black.opacity(0.3), radius: 2)
          .allowsHitTesting(false)
        
        ZStack {
          Color.primaryLight.opacity(0.9)
          
          VStack {
            if !locationViewModel.isSearching {
              Button(locationViewModel.pickerCity) {
                locationViewModel.commitPickerValues()
                locationViewModel.pickerIsPresented.toggle()
              }
              .font(Font.custom("HelveticaNeue", size: 20))
              .foregroundColor(.contrast)
              .minimumScaleFactor(0.75)
              .buttonStyle(PlainButtonStyle())
              .frame(height: 32)
              .padding(EdgeInsets(top: 16, leading: 32, bottom: 8, trailing: 32))
              .onAppear() {
                withAnimation(Animation.default.repeatForever(autoreverses: false).speed(0.25)) {
                  isLoadingAnimation = false
                }
              }
            } else {
              Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.contrast, lineWidth: 2)
                .frame(width: 32, height: 32)
                .rotationEffect(Angle(degrees: isLoadingAnimation ? 360 : 0))
                .padding(EdgeInsets(top: 16, leading: 32, bottom: 8, trailing: 32))
                .onAppear() {
                  withAnimation(Animation.default.repeatForever(autoreverses: false).speed(0.25)) {
                    isLoadingAnimation = true
                  }
                }
            }
            Color.contrast
              .frame(width: 100, height: 1)
            
            Button("Cancel") {
              locationViewModel.resetPickerValues()
              locationViewModel.pickerIsPresented.toggle()
            }
            .font(Font.custom("HelveticaNeue-Bold", size: 20))
            .foregroundColor(.contrast)
            .buttonStyle(PlainButtonStyle())
            .frame(height: 32)
            .padding(EdgeInsets(top: 8, leading: 32, bottom: 16, trailing: 32))
          }
        }
        .clipShape(RoundedRectangle(cornerRadius:20))
        .frame(width: geometry.size.width/1.5, height: 97)
        .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height * 0.83))
        .shadow(color: .black.opacity(0.3), radius: 2)
        
#if !os(macOS)
        Rectangle()
          .fill(
            LinearGradient(gradient:
                            Gradient(colors: [Color.primaryLight.opacity(0),
                                              Color.primaryLight.opacity(0)]),
                           startPoint: .top,
                           endPoint: .bottom)
          )
          .frame(width: geometry.size.width, height: 80)
          .position(CGPoint(x: geometry.size.width / 2, y: 40))
#endif
      }
    }
  }
}

struct LocationPickerView_Previews: PreviewProvider {
  static var previews: some View {
    LocationPickerView()
      .environmentObject(LocationViewModel())
  }
}
