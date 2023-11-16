//
//  DateFormatterUtility.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 14/11/23.
//

import Foundation

class DateFormatterUtility {

    static let shared = DateFormatterUtility()

    private init() {}

    // MARK: - Formatting Methods

    func string(from date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    func date(from string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }

    func currentDateString(format: String) -> String {
        let currentDate = Date()
        return string(from: currentDate, format: format)
    }
}
