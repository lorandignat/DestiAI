//
//  UnsplashImageService.swift
//  DestiAI
//
//  Created by Lorand Ignat on 16.05.2023.
//

import Foundation

class UnsplashImageService: ImageService {
  
  private let url = "https://mockbin.org/bin/46bdb3d8-0d98-46eb-81c9-8761032b2f8c"
//  "https://api.unsplash.com/search/photos"
  
  private let apiKey = "[UNSPLASH_IMAGE_API_KEY]"
  
  func search(for query: String) async -> [URL]? {
    
    guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
          let url = URL(string: "\(url)?page=1&per_page=5&query=\(encodedQuery)") else {
      return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      var images = [URL]()
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      
      if let json = json as? [String: Any],
         let results = json["results"] as? [Any] {
        
        for index in 0..<results.count {
         
          if let result = results[index] as? [String: Any],
             let urls = result["urls"] as? [String: Any],
             let url = urls["regular"] as? String,
             let imageUrl = URL(string: url) {
            if let fileUrl = try await download(from: imageUrl) {
              images.append(fileUrl)
            }
          }
        }
      }
      return images.count > 0 ? images : nil
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
  
  private func download(from url: URL) async throws -> URL? {
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first else {
      return nil
    }
    let fileName = documentsDirectory.appendingPathComponent("\(Date().timeIntervalSince1970).jpg")
    try data.write(to: fileName)
    
    return fileName
  }
}
