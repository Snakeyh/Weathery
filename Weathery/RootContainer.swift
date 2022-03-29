//
//  RootDependencyContainer.swift
//  Weathery
//
//  Created by Jakub Dudek on 2022-03-27.
//

import Foundation
import UIKit

class RootContainer {
    private let userDataService = UserDataService()
    
    init() {}

    private func makeDetailVM(weatherData: [WeatherResponse]) -> DetailViewModel {
        return DetailViewModel(weatherData: weatherData, 
                               cityService: userDataService)
    }
    
    private func makeMainPageVM() -> MainPageViewModel {
        return MainPageViewModel(currentCityService: userDataService, 
                                 makeDetailViewModel: { data in
            return self.makeDetailVM(weatherData: data)
        })
    }
    
    private func makeMainPageVC() -> UIViewController {
        return MainPageViewController(vm: makeMainPageVM())
    }
    
    func makeInitalScreen() -> UIViewController {
        let nc = UINavigationController(rootViewController: makeMainPageVC())
        nc.isNavigationBarHidden = true
        nc.navigationBar.tintColor = .black
        return nc
    }
    
}

