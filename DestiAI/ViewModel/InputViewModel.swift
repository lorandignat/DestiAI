//
//  MainViewModel.swift
//  DestiAI
//
//  Created by Lorand Ignat on 19.04.2023.
//

import Foundation

class InputViewModel: ObservableObject {
  
  let pageCount = PromptData.numberOfCategories() + 2
  
  @Published var currentPage = 0 {
    didSet {
      if maxPage < currentPage {
        maxPage = currentPage
      }
    }
  }
  @Published var maxPage = 0
  @Published private(set) var prompt: String = ""
  @Published private(set) var currentOptionsSelected = [Int: Int]()
  
  func numberOfQuestions() -> Int {
    PromptData.numberOfCategories()
  }
  
  func question(for page: Int) -> String {
    PromptData.question(for: page)
  }
  
  func numberOfOptions(for page: Int) -> Int {
    PromptData.options(for: page).count
  }
  
  func options(for page: Int) -> [String] {
    PromptData.options(for: page)
  }
  
  func select(option: Int, for page: Int) {
    currentOptionsSelected[page] = option
    prompt = PromptData.prompt(for: currentOptionsSelected)
    if currentPage < pageCount - 1 {
      currentPage += 1
    }
  }
}
