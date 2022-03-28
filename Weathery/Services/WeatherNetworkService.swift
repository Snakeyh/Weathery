//
//  NetworkService.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import Foundation
import UIKit
import CoreLocation

class WeatherRequestHandler: WeatherResolver {
    
    // Add API key here!
    private let apiKey = ""
    private let baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/onecall/timemachine")!
    
    private var dispatchGroup: DispatchGroup?
    private var currentTasks: [URLSessionDataTask] = []
    
    private func prepareUrlWith(location: CLLocation, date: Date) -> URL {
        
        var components = baseURL
        components.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "dt", value: date.formattedTimeInterval),
            URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(location.coordinate.longitude))
        ]
        
        return components.url!
    }
        
    private func weatherFor(location: CLLocation, at date: Date, completion: @escaping (Result<WeatherResponse, Error>) -> Void) -> URLSessionDataTask {
        
        let request = URLRequest(url: prepareUrlWith(location: location, date: date))
        
        return URLSession.shared.dataTask(with: request) {(data, response, error) in
                
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, 
                httpResponse.statusCode != 200 { 
                completion(.failure(RequestError.unrecognizedResponseCode))
                return 
            }
            
            guard let data = data else { 
                completion(.failure(RequestError.dataMissing))
                return 
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
            
        }
        
    }
    
    func weatherFor(location: CLLocation, completion: @escaping (Result<[WeatherResponse], Error>) -> Void) {
        
        let group = DispatchGroup()
        var results: [Result<WeatherResponse, Error>] = []
        
        /// Clear previous task if multiple requests have been performed
        if !currentTasks.isEmpty {
            currentTasks.forEach { $0.cancel() }
        }
        
        for i in Array(0..<5) {
            group.enter()
            let date = Date().withSubstructed(days: i)
            let task = weatherFor(location: location, at: date, completion: { weatherData in 
                results.append(weatherData)
                group.leave()
            })
            currentTasks.append(task)
        }
        
        currentTasks.forEach { $0.resume() }
        
        group.notify(queue: DispatchQueue.main, execute: { [weak self] in
            /// Clear tasks since they are done
            self?.currentTasks = []
            
            let errors: [Error] = results.compactMap({
                if case .failure(let error) = $0 {
                    return error
                }
                return nil
            })
            
            guard errors.isEmpty else {
                completion(.failure(errors.first!))
                return
            }
            
            let weatherResponses: [WeatherResponse] = results.compactMap({
                if case .success(let weather) = $0 {
                    return weather
                }
                return nil
            })
            
            completion(.success(weatherResponses))
        })
    }
    
    enum RequestError: LocalizedError {
        case unrecognizedResponseCode
        case dataMissing
        
        var errorDescription: String? {
            return "Something went wrong, please try again later"
        }
    }
    
    
    
}




