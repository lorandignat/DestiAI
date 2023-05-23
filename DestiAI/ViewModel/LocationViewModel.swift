//
//  LocationViewModel.swift
//  DestiAI
//
//  Created by Lorand Ignat on 24.04.2023.
//

import Foundation
import MapKit

// TODO: Refactor - split into LocationViewModel and LocationPickerViewModel

class LocationViewModel: NSObject, ObservableObject {
  
  // Default Values
  static private let defaultCity = "Cupertino, California"
  static private let defaultMapSpan = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
  static private let defaultCoordinates = CLLocationCoordinate2D(latitude: 37.332331, longitude: -122.031219)
  
  // Services
  // TODO: Service factory/provider
  private let locationManager = CLLocationManager()
  private var geocoderService: GeocoderService = AppleGeocoderService()
  private var shouldStopSearchingForInitialLocation = false
  
  // Presentation State
  @Published var pickerIsPresented = false
  
  // Location View State
  @Published var city = defaultCity
  @Published var region = MKCoordinateRegion(center: defaultCoordinates, span: defaultMapSpan)
  
  // Location Picker View State
  @Published var pickerCity = defaultCity
  @Published var pickerRegion = MKCoordinateRegion(center: defaultCoordinates, span: defaultMapSpan)
  
  // Location Search
  @Published var isSearching = false
  private var lastSearchedPickerRegion = MKCoordinateRegion(center: defaultCoordinates, span: defaultMapSpan)
  private var searchTask: DispatchWorkItem?
  
  override init() {
    
    super.init()
      
    if !(readLocationData()) {
      locationManager.desiredAccuracy = kCLLocationAccuracyReduced
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
    }
  }
  
  func stopSearchingForInitialLocation() {
    shouldStopSearchingForInitialLocation = true
  }
}

// TODO: Refactor - extract persistance logic

extension LocationViewModel {
  
  private func writeLocationData() {
    
    UserDefaults.standard.set(city, forKey: "destiAi.locationViewModel.city")
    UserDefaults.standard.set(region.center.latitude, forKey: "destiAi.locationViewModel.latitude")
    UserDefaults.standard.set(region.center.longitude, forKey: "destiAi.locationViewModel.longitude")
  }
  
  private func readLocationData() -> Bool {
    
    if let city = UserDefaults.standard.string(forKey: "locationViewModel.city") {
      let latitude = UserDefaults.standard.double(forKey: "locationViewModel.latitude")
      let longitude = UserDefaults.standard.double(forKey: "locationViewModel.longitude")
      
      self.city = city
      self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: Self.defaultMapSpan)
      
      self.pickerCity = self.city
      self.pickerRegion = self.region
      self.lastSearchedPickerRegion = self.region
      
      return true
    }
    return false
  }
}

extension LocationViewModel {
  
  func pickerValuesChanged() {
    if abs(lastSearchedPickerRegion.center.latitude - pickerRegion.center.latitude) > 0.01 ||
        abs(lastSearchedPickerRegion.center.longitude - pickerRegion.center.longitude) > 0.01 {
      searchTask?.cancel()
      searchTask = DispatchWorkItem {
        self.lastSearchedPickerRegion = self.pickerRegion
        Task {
          let city = await self.geocoderService.data(for: (lat: self.pickerRegion.center.latitude,
                                                           long: self.pickerRegion.center.longitude))
          if let city {
            DispatchQueue.main.async {
              self.isSearching = false
              self.pickerCity = city
            }
          }
        }
      }
      if let searchTask {
        DispatchQueue.main.async {
          self.isSearching = true
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: searchTask)
      }
    }
  }
  
  func resetPickerValues() {
    pickerCity = city
    pickerRegion = region
    lastSearchedPickerRegion = region
  }
  
  func commitPickerValues() {
    city = pickerCity
    region = pickerRegion
    
    writeLocationData()
  }
}

extension LocationViewModel: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    manager.stopUpdatingLocation()
    
    Task {
      if !shouldStopSearchingForInitialLocation, let location = locations.first {
        let city = await geocoderService.data(for: (lat: location.coordinate.latitude, long: location.coordinate.longitude))
        
        DispatchQueue.main.async {
          if !self.shouldStopSearchingForInitialLocation, let city = city {
            self.city = city
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: Self.defaultMapSpan)
            
            self.writeLocationData()
          }
        }
      }
    }
  }
}
