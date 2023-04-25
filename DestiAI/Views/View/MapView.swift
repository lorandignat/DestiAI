//
//  MapView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 24.04.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
  
  @Binding var region: MKCoordinateRegion
  
  var body: some View {
    let binding = Binding(
      get: { self.region },
      set: { newValue in
        DispatchQueue.main.async {
          self.region = newValue
        }
      }
    )
    return Map(coordinateRegion: binding)
  }
}
