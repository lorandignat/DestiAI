//
//  ImageSearchService.swift
//  DestiAI
//
//  Created by Lorand Ignat on 16.05.2023.
//

import Foundation

protocol ImageService {
  func search(for query: String) async -> [URL]?
}
