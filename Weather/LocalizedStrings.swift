//
//  LocalizedStrings.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/13/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

struct LocalizedStrings {
    
    struct WeatherSearchBar {
        
        static let currentForecastScopeButtonTitle = NSLocalizedString("searchBar.scopeButton.currentForecast.title", comment: "")
        static let weeklyForecastScopeButtonTitle = NSLocalizedString("searchBar.scopeButton.weeklyForecast.title", comment: "")
        static let placeholderText = NSLocalizedString("searchBar.placeholder.text", comment: "")
    }
    
    struct WeatherView {
        static func windSpeedDescription(speed: Double) -> String {
            return String.localizedStringWithFormat(NSLocalizedString("weatherView.wind.speed.description", comment: ""), speed)
        }
        
        static func humidityDescription(humidity: Int) -> String {
            return String.localizedStringWithFormat(NSLocalizedString("weatherView.humidity.description", comment: ""), humidity)
        }
        
        static func pressureDescription(pressure: Int) -> String {
            return String.localizedStringWithFormat(NSLocalizedString("weatherView.pressure.description", comment: ""), pressure)
        }
    }
}
