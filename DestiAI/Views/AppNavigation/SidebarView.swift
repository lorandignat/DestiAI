//
//  Sidebar.swift
//  DestiAI
//
//  Created by Lorand Ignat on 20.04.2023.
//

import SwiftUI

struct SidebarView: View {
  
  @EnvironmentObject var navigationRouter: SplitViewNavigationRouter
  @EnvironmentObject var suggestionViewModel: SuggestionViewModel
  
  var body: some View {
    List(selection: $navigationRouter.index) {
      Section() {
        HStack {
          Spacer()
          Text("DestiAI")
#if os(macOS)
            .font(Font.custom("HelveticaNeue-Bold", size: 16))
#else
            .font(Font.custom("HelveticaNeue-Bold", size: 24))
#endif
            .foregroundColor(Color.primaryLight)
          Spacer()
        }
        .tag(0)
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
        .listRowBackground(Color.primaryMedium)
        .background(navigationRouter.index == nil ?
                    (navigationRouter.lastIndex == 0 ? Color.contrast : Color.primaryMedium) :
                    (navigationRouter.index == 0 ? Color.contrast : Color.primaryMedium))
      }
      
      Section(header:
                HStack {
        Text(suggestionViewModel.suggestions.count > 0 ? "History" :
              "No search history")
        .foregroundColor(Color.primaryDark)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        Spacer()
      }) {
        ForEach(0..<suggestionViewModel.suggestions.count, id: \.self) { index in
          HStack {
            Text("\(formatedDate(from: suggestionViewModel.suggestions[index].date)) - \(suggestionViewModel.suggestions[index].location)")
#if os(macOS)
              .font(Font.custom("HelveticaNeue-Bold", size: 12))
#else
              .font(Font.custom("HelveticaNeue-Bold", size: 16))
#endif
              .foregroundColor(Color.primaryLight)
              .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            Spacer()
            Image(systemName: "trash")
              .onTapGesture {
                delete(index: index)
              }
              .foregroundColor(Color.primaryLight)
              .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
          }
          .tag(index + 1)
          .listRowBackground(Color.primaryMedium)
          .background(navigationRouter.index == nil ?
                      (navigationRouter.lastIndex == index + 1 ? Color.contrast : Color.primaryMedium) :
                      (navigationRouter.index == index + 1 ? Color.contrast : Color.primaryMedium))
        }
        .background(Color.primaryMedium)
        .listRowSeparator(.hidden)
      }
    }
#if !os(macOS)
    .listStyle(.insetGrouped)
#endif
    .tint(Color.primaryMedium)
    .accentColor(Color.primaryMedium)
    .background(Color.primaryMedium)
    .scrollContentBackground(.hidden)
  }
  
  func delete(index: Int) {
    if navigationRouter.lastIndex == index + 1 {
      navigationRouter.index = index
    } else if navigationRouter.lastIndex >= index {
      navigationRouter.lastIndex -= 1
    }
    suggestionViewModel.remove(at: index)
  }
  
  func formatedDate(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_us")
    formatter.setLocalizedDateFormatFromTemplate("MMM dd")
    return formatter.string(from: date)
  }
}

struct SidebarView_Previews: PreviewProvider {
  static var previews: some View {
    SidebarView()
      .environmentObject(SplitViewNavigationRouter())
      .environmentObject(SuggestionViewModel())
  }
}
