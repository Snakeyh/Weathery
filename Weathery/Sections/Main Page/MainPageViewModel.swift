//
//  MainPageViewModel.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import Foundation
import CoreLocation

protocol LocationResolver {
    func getLocationFor(city: String, completion: @escaping (Result<CLLocation, Error>) -> Void)
}

protocol WeatherResolver {
    func weatherFor(location: CLLocation, completion: @escaping (Result<[WeatherResponse], Error>) -> Void)
}

class MainPageViewModel {
    
    enum State {
        case loading
        case weather
        case error(Error)
    }
    
    private let locationResovler: LocationResolver
    private let currentCityService: CurrentCityService
    private let weatherResolver: WeatherResolver
    private let makeDetailViewModel: ([WeatherResponse]) -> DetailViewModel 
    
    var onStateChange: ((State) -> Void)?

    private(set) var currentCity: String {
        get {
            return currentCityService.city
        }
        
        set {
            currentCityService.city = newValue
        }
    }
    
    private(set) var state: State = .loading {
        didSet {
            onStateChange?(state)
        }
    }
    
    private var weatherData: [WeatherResponse]? = nil {
        didSet {
            if weatherData != nil {
                state = .weather
            }
        }
    }
    
    init(locationResolver: LocationResolver = GeocodingService(),
         weatherResolver: WeatherResolver = WeatherRequestHandler(),
         currentCityService: CurrentCityService,
         makeDetailViewModel: @escaping ([WeatherResponse]) -> DetailViewModel 
    ) {
        self.locationResovler = locationResolver
        self.weatherResolver = weatherResolver
        self.currentCityService = currentCityService
        self.makeDetailViewModel = makeDetailViewModel
        
        loadWeather(for: currentCity)
    }
    
    private func loadWeather(for city: String) {
        state = .loading
        locationResovler.getLocationFor(city: city, completion: { [weak self] res in
            guard let self = self else { return }
            switch res {
            case .success(let location):
                self.weatherResolver.weatherFor(location: location, completion: { result in
                    switch result {
                    case .success(let weatherData):
                        self.weatherData = weatherData
                    case .failure(let error):
                        self.state = .error(error)
                    }
                })
            case .failure(let error):
                self.state = .error(error)
            }
        })
    }
    
    private func getCurrentWeather() -> WeatherContainer? {
        guard let weatherData = weatherData else {
            return nil
        }
        
        guard let latestWeather =  weatherData.sorted(by: { $0.current.dt > $1.current.dt}).first else {
            return nil
        }
        
        return latestWeather.current
    }

    func temperatureLabel() -> String? {
        guard let currentWeather = getCurrentWeather() else {
            return nil
        }
        
        return currentWeather.temp.kelvinToLocaleTemp
    }
    
    func descriptionLabel() -> String? {
        guard let currentWeather = getCurrentWeather(), 
                let weatherDesciription = currentWeather.weather.first?.description else {
            return nil
        }
        
        return weatherDesciription.capitalized
    }
    
    func didEndEditing(with text: String?) {
        
        guard let text = text, 
                    !text.isEmpty,
                        text != currentCity else { return }
        
        
        currentCity = text
        loadWeather(for: text)
    }
    
    func detailViewModel() -> DetailViewModel? {
        guard let weatherData = weatherData else {
            return nil
        }
        
        return makeDetailViewModel(weatherData)
    }
    
}

