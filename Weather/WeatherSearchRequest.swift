//
//  WeatherSearchRequest.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/13/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

protocol WeatherSearchRequestDelegate: class {
    func weatherSearchRequest(_ request: WeatherSearchRequest, didRecieveCurrent weather: Weather)
    func weatherSearchRequest(_ request: WeatherSearchRequest, didRecieveWeekly weather: [Weather])
}

final class WeatherSearchRequest {
    
    // MARK: - Type
    
    enum Kind {
        case current, weekly
    }
    
    // MARK: - Properties
    
    weak var delegate: WeatherSearchRequestDelegate?
    private static let nonNumberCharacters = NSCharacterSet.decimalDigits.inverted
    
    // MARK: - Lifecycle
    
    init() {

    }
    
    // MARK: - Private 
    
    private static func isZipCode(searchTerm: String) -> Bool {
        // assume if a non-number character is found in the search term, it is not a zip code
        return searchTerm.rangeOfCharacter(from: WeatherSearchRequest.nonNumberCharacters) == nil
    }
    
    private func recievedCurrentData(weather: Weather?) {
        guard let weatherObject = weather else { return }
        Thread.executeOnMainThread {
            self.delegate?.weatherSearchRequest(self, didRecieveCurrent: weatherObject)
        }
    }
    
    private func recievedWeeklyData(weatherObjects: [Weather]) {
        guard !weatherObjects.isEmpty else { return }
        Thread.executeOnMainThread {
            self.delegate?.weatherSearchRequest(self, didRecieveWeekly: weatherObjects)
        }
    }
    
    // MARK: - Public
    
    func executeRequestWith(searchTerm: String, type: Kind) {
        
        guard !searchTerm.isEmpty else { return }
        if WeatherSearchRequest.isZipCode(searchTerm: searchTerm) {
            // handle for zip code
            switch type {
            case .current:
                _ = FetchCurrentWeatherData(zipCode: searchTerm) { (weather, error) in
                    self.recievedCurrentData(weather: weather)
                }
            
            case .weekly:
                _ = FetchWeeklyWeatherData(zipCode: searchTerm) { (weatherObjects, error) in
                    self.recievedWeeklyData(weatherObjects: weatherObjects)
                }
            }
            
        } else {
            // handle for city
            
            switch type {
            case .current:
                _ = FetchCurrentWeatherData(cityName: searchTerm) { (weather, error) in
                    self.recievedCurrentData(weather: weather)
                }
                
            case .weekly:
                _ = FetchWeeklyWeatherData(cityName: searchTerm) { (weatherObjects, error) in
                    self.recievedWeeklyData(weatherObjects: weatherObjects)
                }
            }
        }
    }
}
