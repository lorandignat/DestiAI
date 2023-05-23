//
//  Date+Formatted.swift
//  DestiAI
//
//  Created by Lorand Ignat on 04.05.2023.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
