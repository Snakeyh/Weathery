//
//  DateExtensions.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import Foundation

extension Date {
    var formattedTimeInterval: String {
        return String(Int(self.timeIntervalSince1970))
    }
    
    func withSubstructed(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: self)!
    }
}
