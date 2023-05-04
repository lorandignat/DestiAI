//
//  ChatGPTService.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import Foundation

struct ChatGPTService {
  
  private let url = URL(string: "https://mockbin.org/bin/896a50ca-cb34-425b-8c66-ac2ec14d71b2")!
//  URL(string: "https://api.openai.com/v1/completions")!
  
  private let apiKey = ""
//  "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"
  
  private let guideline = "Answer in this JSON format: {\"location\":,\"description\":,\"weather\":,\"activities\":{\"activityName\":\"description\"},\"hotels\":{\"hotelName\":\"description\"}}"
  
  func performRequest(for prompt: String, completion: @escaping (_ suggestion: Suggestion?) -> ()) {
    
    guard let request = buildRequest(for: prompt) else {
      completion(nil)
      return
    }
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in

      if let error = error {
        print("Error: \(error.localizedDescription)")
        completion(nil)
        return
      }
      
      guard let data = data else {
        print("No data received")
        completion(nil)
        return
      }
      
      handleResponse(data: data, completion: completion)
    }
    task.resume()
  }
  
  private func handleResponse(data: Data, completion: @escaping (_ suggestion: Suggestion?) -> ()) {
    
    // Parse the JSON response
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      print("Response: \(json)")
      
      if let json = json as? Dictionary<String, Any>,
         let choices = json["choices"] as? Array<Any>,
         let choice = choices.first as? Dictionary<String, Any>,
         let text = choice["text"] as? String {
        
        let cleanedText = text.replacingOccurrences(of: "\\", with: "")
        if let first = cleanedText.firstIndex(of: "{"),
           let last = cleanedText.lastIndex(of: "}"),
           let textData = String(cleanedText[first...last]).data(using: .utf8) {
          
          let suggestion = try JSONDecoder().decode(Suggestion.self, from: textData)
          completion(suggestion)
          return
        }
      }
      completion(nil)
    } catch {
      print(error.localizedDescription)
      completion(nil)
    }
  }
  
  private func buildRequest(for prompt: String) -> URLRequest? {
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let parameters = [
      "prompt": prompt + " " + guideline,
      "temperature": 0.75,
      "max_tokens": 750,
      "n": 1,
      "model": "text-davinci-002"
    ] as [String: Any]
    
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
      return request
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
}
