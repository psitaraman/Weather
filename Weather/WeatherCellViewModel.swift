//
//  WeatherCellViewModel.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/15/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

struct WeatherCellViewModel {
    
    // MARK: - Properties
    let cityNameText: String
    let descriptionText: String
    let verboseDescriptionText: String
    let windSpeedText: String
    let humidityText: String
    let pressureText: String
    let dateText: String
    let timeText: String
    let temperatureText: String
    let highTemperatureText: String
    let lowTemperatureText: String
    
    private static let dateFormatter = DateFormatter(format: "MM/dd/yy")
    private static let timeFormatter = DateFormatter(format: "HH:mm a")
    
    // MARK: - Lifecycle
    
    init(weather: Weather) {
        
        self.cityNameText = weather.location.name.capitalized
        self.descriptionText = weather.description.capitalized
        self.verboseDescriptionText = weather.verboseDescription.capitalized
        self.windSpeedText = LocalizedStrings.WeatherView.windSpeedDescription(speed: Double(weather.wind.speed))
        self.humidityText = LocalizedStrings.WeatherView.humidityDescription(humidity: weather.humidity)
        self.pressureText = LocalizedStrings.WeatherView.pressureDescription(pressure: weather.pressure)
        self.dateText = WeatherCellViewModel.dateFormatter.string(from: weather.date)
        self.timeText = WeatherCellViewModel.timeFormatter.string(from: weather.date)
        self.temperatureText = "\(weather.temperature) F"
        self.highTemperatureText = "\(weather.maxTemperature) F"
        self.lowTemperatureText = "\(weather.minTemperature) F"
    }
}
