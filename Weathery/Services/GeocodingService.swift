//
//  GeoLocationService.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import CoreLocation

class GeocodingService: CLGeocoder {
    
    func getLocationFor(city: String, completion: @escaping (Result<CLLocation, Error>) -> Void ) {
        if isGeocoding {
            cancelGeocode()
        }
        
        self.geocodeAddressString(city, completionHandler: { marks, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let placemark = marks?.first, let location = placemark.location else {
                completion(.failure(GeocodingError.couldNotFindCity))
                return
            }
            
            completion(.success(location))
        })
    }
    
    enum GeocodingError: LocalizedError {
        case couldNotFindCity
        
        var errorDescription: String? {
            switch self {
            case .couldNotFindCity:
                return "Could not find the city you are searching for."
            }
        }
    }
    
}

extension GeocodingService: LocationResolver {}
