//
//  CurrentCityService.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import Foundation

protocol CurrentCityService: AnyObject {
    var city: String { get set }
}

class UserDataService {
    private let defaults = UserDefaults.standard
    
    enum Key: String {
        case city = "dCity"
    }
    
    //MARK: - City
    var city: String {
        get {
            return defaults.string(forKey: Key.city.rawValue) ?? "Göteborg"
        }
        set {
            defaults.set(newValue, forKey: Key.city.rawValue)
        }
    }
}


extension UserDataService: CurrentCityService {}
