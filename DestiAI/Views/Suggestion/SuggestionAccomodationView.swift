//
//  SuggestionWeatherView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 30.05.2023.
//

import SwiftUI

struct SuggestionAccomodationView: View {
  
  var hotels: [String: String]
  var images: [URL?]?
  
  var body: some View {
    GeometryReader { geometry in
      Color.primaryLight.ignoresSafeArea()
      VStack {
        Spacer()
        if let images = images?.compactMap({ $0 }) {
          ForEach(0..<images.count, id: \.self) { index in
            HStack {
              if index % 2 == 1 {
                Spacer()
              }
              AsyncImage(url: images[index]) { image in
                image.resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(
                    width: geometry.size.width / 3 * 2 + 50,
                    height: geometry.size.height / CGFloat((images.count + 1))
                  )
                  .clipped()
              } placeholder: {
                EmptyView()
              }
              .frame(
                width: geometry.size.width / 3 * 2 + 50,
                height: geometry.size.height / CGFloat((images.count + 1))
              )
              .clipped()
              .ignoresSafeArea()
              if index % 2 == 0 {
                Spacer()
              }
            }
            Spacer()
          }
        }
        Spacer()
      }
      VStack {
        let keys = Array<String>(hotels.keys)
        Spacer()
        ForEach(0..<keys.count, id: \.self) { index in
          HStack {
            if index % 2 == 0 {
              Spacer()
            }
            ZStack {
              Color.light
              VStack {
                Text(keys[index])
                  .font(Font.custom("HelveticaNeue", size: 20))
                  .minimumScaleFactor(0.25)
                  .foregroundColor(Color.contrast)
                  .padding(EdgeInsets(top: 10, leading: 20, bottom: 4, trailing: 30))
                  .multilineTextAlignment(.leading)
                Text(hotels[keys[index]]!)
                  .font(Font.custom("HelveticaNeue", size: 20))
                  .minimumScaleFactor(0.25)
                  .foregroundColor(Color.contrast)
                  .padding(EdgeInsets(top: 4, leading: 20, bottom: 10, trailing: 30))
                  .multilineTextAlignment(.leading)
              }
            }
            .frame(
              width: geometry.size.width / 3 * 2,
              height: geometry.size.height / CGFloat((keys.count + 2))
            )
            if index % 2 == 1 {
              Spacer()
            }
          }
          Spacer()
        }
        Spacer()
      }
    }
  }
}

struct SuggestionWeatherView_Previews: PreviewProvider {
    static var previews: some View {
      SuggestionAccomodationView(hotels: ["Hotel1":"Description"], images: nil)
    }
}
