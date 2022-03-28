//
//  Temperature.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-28.
//

import Foundation

extension Double {
    var kelvinToLocaleTemp: String {
        /// Measurement api can be used here but it's iOS10+
        var temp = self - 273.15 /// Kelvin to celsius
        let isMetric = Locale.current.usesMetricSystem
        
        if !isMetric {
            temp = temp * 9/5 + 32
        }
        
        return "\(Int(temp))°\(isMetric ? "C":"F")"
    }
}
