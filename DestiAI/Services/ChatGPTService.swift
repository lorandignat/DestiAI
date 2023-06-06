//
//  ChatGPTService.swift
//  DestiAI
//
//  Created by Lorand Ignat on 03.05.2023.
//

import Foundation

class ChatGPTService: SuggestionService {
  
  private let url = URL(string: "https://mockbin.org/bin/3aa6829b-08be-4a61-b288-fb8056e9e880/")!
//  URL(string: "https://api.openai.com/v1/completions")!
  
  private let apiKey = "[CHAT_GPT_API_KEY]"
  
  private let guideline = "Suggestion should be exactly in this valid JSON format replacing only the strings between <> signes: {\"location\":\"<name>\",\"description\":\"<description>\",\"suggestedActivities\":{\"<nameOfActivity>\":\"<shortDescriptionOfActivity>\",\"<nameOfActivity>\":{\"<shortDescriptionOfActivity>\",\"<nameOfActivity>\":\"<shortDescriptionOfActivity>\"},\"suggestedHotels\":{\"<nameOfHotel>\":\"<shortDescriptionOfHotel>\",\"<nameOfHotel>\":\"<shortDescriptionOfHotel>\"}}"
  
  func requestSuggestion(for prompt: String) async -> Suggestion? {
    
    guard let request = buildRequest(for: prompt) else {
      return nil
    }
    return await perform(request: request)
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
  
  private func perform(request: URLRequest) async -> Suggestion? {
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      return handleResponse(data: data)
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
  
  private func handleResponse(data: Data?) -> Suggestion? {
    
    guard let data = data else {
      print("No data received")
      return nil
    }
    
    // Parse the JSON response
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      print("Response: \(json)")
      
      if let textData = self.extractTextData(fromJsonObject: json) {
          let suggestion = try JSONDecoder().decode(Suggestion.self, from: textData)
          return suggestion
      }
      return nil
    } catch {
      print(error.localizedDescription)
      return nil
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
