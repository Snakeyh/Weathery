//
//  Weather.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import Foundation

struct WeatherResponse: Decodable {
    var current: WeatherContainer
    var hourly: [WeatherContainer]
}

struct WeatherContainer: Decodable {
    var dt: TimeInterval
    var temp: Double
    var weather: [Weather]
}

struct Weather: Decodable {
    var description: String
}


