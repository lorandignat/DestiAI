//
//  SuggestionActivitiesView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 29.05.2023.
//

import SwiftUI

struct SuggestionActivitiesView: View {
  
  var activities: [String: String]
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
        let keys = Array<String>(activities.keys)
        Spacer().frame(maxHeight: 16)
        ForEach(0..<keys.count, id: \.self) { index in
          HStack {
            if index % 2 == 0 {
              Spacer()
            }
            ZStack {
              Color.light
              VStack {
                Text(keys[index].capitalized)
                  .font(Font.custom("HelveticaNeue", size: 18))
                  .minimumScaleFactor(0.5)
                  .foregroundColor(Color.contrast)
                  .padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 20))
                  .multilineTextAlignment(.leading)
                Text(activities[keys[index]]!)
                  .font(Font.custom("HelveticaNeue", size: 18))
                  .minimumScaleFactor(0.5)
                  .foregroundColor(Color.contrast)
                  .padding(EdgeInsets(top: 2, leading: 10, bottom: 8, trailing: 20))
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
        Spacer()
      }
    }
  }
}

struct SuggestionActivitiesView_Previews: PreviewProvider {
  static var previews: some View {
    SuggestionActivitiesView(activities: ["ActivitiyOne":"ActivitiyDescription"], images: nil)
  }
}
