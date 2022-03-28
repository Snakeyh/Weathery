//
//  DetailViewModel.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import Foundation

class DetailViewModel {
    
    private let weatherPoints: [WeatherContainer]
    
    var title: String
    
    init(weatherData: [WeatherResponse], cityService: CurrentCityService) {
        self.weatherPoints = weatherData.flatMap { $0.hourly }
        self.title = cityService.city
    }
    
    func averageTemperature() -> String {
        let average = weatherPoints.reduce(0.0, { $0 + $1.temp }) / Double(weatherPoints.count)
        return "Average: \(average.kelvinToLocaleTemp)"
    }
    
    func medianTemperature() -> String {
        let median = weatherPoints.map { $0.temp }.median()!
        return "Median: \(median.kelvinToLocaleTemp)"
    }
    
    func maxTemperature() -> String {
        let max = weatherPoints.map { $0.temp }.max()!
        return "Max: \(max.kelvinToLocaleTemp)"
    }
    
    func minTemperature() -> String {
        let min = weatherPoints.map { $0.temp }.min()!
        return "Min: \(min.kelvinToLocaleTemp)"
    }
    
}


fileprivate extension Array where Element == Double {
    func median() -> Double? {
        guard count > 0  else { return nil }

        let sortedArray = self.sorted()
        if count % 2 != 0 {
            return Double(sortedArray[count/2])
        } else {
            return Double(sortedArray[count/2] + sortedArray[count/2 - 1]) / 2.0
        }
    }
}
