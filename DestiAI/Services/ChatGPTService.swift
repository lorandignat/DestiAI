//
//  ChatGPTService.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import Foundation

class ChatGPTService: SuggestionService {
  
  private let url = URL(string: "https://mockbin.org/bin/d0ea6172-9e38-4775-9af8-e5ab24b0342f")!
// URL(string: "https://api.openai.com/v1/completions")!
  private let apiKey = "[CHAT_GPT_API_KEY]"
  
  private let guideline = "Answer in this JSON format: {\"location\":,\"description\":,\"weather\":,\"activities\":{\"activityName\":\"description\"},\"hotels\":{\"hotelName\":\"description\"}}"
  
  func requestSuggestion(for prompt: String, completion: @escaping (_ suggestion: Suggestion?) -> ()) {
    
    guard let request = buildRequest(for: prompt) else {
      completion(nil)
      return
    }
    perform(request: request, with: completion)
  }
}

extension ChatGPTService {
  
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
  
  private func perform(request: URLRequest, with completion: @escaping (_ suggestion: Suggestion?) -> ()) {
    let session = URLSession.shared
    let task = session.dataTask(with: request) { [weak self] data, response, error in
      self?.handleResponse(data: data, response: response, error: error, completion: completion)
    }
    task.resume()
  }
  
  private func handleResponse(data: Data?,
                              response: URLResponse?,
                              error: Error?,
                              completion: @escaping (_ suggestion: Suggestion?) -> ()) {
    
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
    
    // Parse the JSON response
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      print("Response: \(json)")
      
      if let textData = self.extractTextData(fromJsonObject: json) {
          let suggestion = try JSONDecoder().decode(Suggestion.self, from: textData)
          completion(suggestion)
          return
      }
      completion(nil)
    } catch {
      print(error.localizedDescription)
      completion(nil)
    }
  }
  
  private func extractTextData(fromJsonObject json: Any) -> Data? {
    if let json = json as? Dictionary<String, Any>,
       let choices = json["choices"] as? Array<Any>,
       let choice = choices.first as? Dictionary<String, Any>,
       let text = choice["text"] as? String,
       let cleanedText = clean(text: text),
       let textData = cleanedText.data(using: .utf8) {
      return textData
    }
    return nil
  }
  
  private func clean(text: String) -> String? {
    
    let cleanedText = text.replacingOccurrences(of: "\\", with: "")
    if let first = cleanedText.firstIndex(of: "{"),
       let last = cleanedText.lastIndex(of: "}") {
      return String(cleanedText[first...last])
    }
    return nil
  }
}
