//
//  AppleGeocoderService.swift
//  DestiAI
//
//  Created by Lorand Ignat on 24.04.2023.
//

import Foundation
import CoreLocation

class AppleGeocoderService: GeocoderService {
  
  private let geocoder = CLGeocoder()
  
  func data(for coordinates: (lat: Double, long: Double)) async -> String? {
    do {
      let placemarks = try await geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.lat, longitude: coordinates.long))
      if let placemark = placemarks.first {
        if let country = placemark.country {
          if let city = placemark.locality {
            if let countryCode = placemark.isoCountryCode, countryCode == "US",
               let state = placemark.administrativeArea {
              if let stateName = longStateName(state) {
                return "\(city), \(stateName)"
              }
              return "\(city), \(state)"
            }
            return "\(city), \(country)"
          }
        }
      }
    } catch {}
    
    return nil
  }
}

extension AppleGeocoderService {
  
  private static let stateCodes = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
  private static let fullStateNames = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
  
  private func longStateName(_ stateCode:String) -> String? {
    let index = AppleGeocoderService.stateCodes.firstIndex(of: stateCode.uppercased())
    if let index {
      return AppleGeocoderService.fullStateNames[index]
    }
    return nil
  }
}
