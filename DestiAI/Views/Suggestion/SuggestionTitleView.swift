//
//  SuggestionTitleView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 23.05.2023.
//

import SwiftUI

struct SuggestionTitleView: View {
  
  let location: String
  let description: String
  let image: URL?
  
  var body: some View {
    GeometryReader { geometry in
      Color.primaryLight.ignoresSafeArea()
      VStack {
        HStack {
          Spacer()
          Text(location)
            .padding(EdgeInsets(top: 48, leading: 32, bottom: 16, trailing: 32))
            .font(Font.custom("HelveticaNeue-Bold", size: 32))
            .minimumScaleFactor(0.75)
            .foregroundColor(Color.contrast)
            .lineLimit(2)
            .multilineTextAlignment(.center)
          Spacer()
        }
        ZStack {
          AsyncImage(url: image) { image in
            image.resizable()
              .aspectRatio(contentMode: .fill)
              .position(CGPoint(x: geometry.size.width / 3, y: geometry.size.height / 7 * 2))
              .frame(
                maxWidth: geometry.size.width,
                maxHeight: geometry.size.height / 5 * 3)
              .clipped()
          } placeholder: {
            EmptyView()
          }
          .position(CGPoint(x: geometry.size.width / 3, y: geometry.size.height / 7 * 2))
          .frame(
            maxWidth: geometry.size.width,
            maxHeight: geometry.size.height / 5 * 3)
          .clipped()
          .ignoresSafeArea()
          
          ZStack {
            Rectangle()
              .fill(Color.primaryMedium)
              .opacity(0.90)
            Text(description)
              .font(Font.custom("HelveticaNeue-Bold", size: 20))
              .minimumScaleFactor(0.25)
              .foregroundColor(Color.primaryLight)
              .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 8))
              .multilineTextAlignment(.leading)
          }
          .position(CGPoint(x: geometry.size.width / 7 * 3,
                            y:  geometry.size.height / 3 + 20))
          .frame(
            maxWidth: geometry.size.width / 5 * 3,
            maxHeight: geometry.size.height / 2)
        }
      }
    }
  }
}

struct SuggestionTitleView_Previews: PreviewProvider {
  static var previews: some View {
    SuggestionTitleView(location: "Cluj Napoca, Romania", description: "Cluj-Napoca, a city in northwestern Romania, is the unofficial capital of the Transylvania region. It's home to universities, vibrant nightlife and landmarks dating to Saxon and Hungarian rule.", image: nil)
  }
}
