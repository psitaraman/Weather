//
//  Weather.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/14/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

struct Weather {
    
    // MARK: - Types
    
    private struct Keys {
        static let identifier = "id"
        static let locationCountryCode = "country"
        static let locationName = "name"
        static let locationLatitude = "lat"
        static let locationLongitude = "lon"
        static let locationCoordinates = "coord"
        
        static let sys = "sys"
        static let wind = "wind"
        static let windSpeedSpeed = "speed"
        static let windSpeedDegrees = "deg"
        
        static let weather = "weather"
        static let currentDate = "dt"
        static let sunrise = "sunrise"
        static let sunset = "sunset"
        static let main = "main"
        static let verboseDescription = "description"
        static let iconPath = "icon"
        static let temperature = "temp"
        static let maxTemperature = "temp_max"
        static let minTemperature = "temp_min"
        static let pressure = "pressure"
        static let humidity = "humidity"
        static let visibility = "visibility"
    }
    
    struct Location {
        let identifier: String
        let countryCode: String
        let name: String
        let latitude: Float
        let longitude: Float
    }
    
    struct Wind {
        let speed: Float
        let degrees: Int
    }
    
    // MARK: - Properties
    
    static let iconRelativePath = "openweathermap.org/img/w/"
    
    let location: Location
    let wind: Wind
    
    let identifier: String
    let date: Date
    let sunrise: Date?
    let sunset: Date?
    let description: String
    let verboseDescription: String
    let iconUrl: URL
    let temperature: Float
    let maxTemperature: Float
    let minTemperature: Float
    let pressure: Int
    let humidity: Int
    let visibility: Int?
    
    // MARK: - Lifecycle
    
    init(dictionary: [String: Any]) {
        
        let locId = String(describing: dictionary[Keys.identifier] as! Int)
        let sysDic = dictionary[Keys.sys] as! [String: Any]
        let locCountryCode = sysDic[Keys.locationCountryCode] as! String
        let locName = dictionary[Keys.locationName] as! String
        let locCoord = dictionary[Keys.locationCoordinates] as! [String: Any]
        let locLat = locCoord[Keys.locationLatitude] as! Float
        let locLong = locCoord[Keys.locationLongitude] as! Float
        
        self.location = Location(identifier: locId, countryCode: locCountryCode, name: locName, latitude: locLat, longitude: locLong)
        
        let windDic = dictionary[Keys.wind] as! [String: Any]
        let speed = windDic[Keys.windSpeedSpeed] as! Float
        let degrees = windDic[Keys.windSpeedDegrees] as! Int
        self.wind = Wind(speed: speed, degrees: degrees)
        
        let weatherArray = dictionary[Keys.weather] as! [[String: Any]]
        let weatherDic = weatherArray.first!
        self.identifier = String(describing: weatherDic[Keys.identifier] as! Int)
        self.date = Date(timeIntervalSince1970: TimeInterval(dictionary[Keys.currentDate]  as! Int))
        self.sunrise = Date(timeIntervalSince1970: TimeInterval(sysDic[Keys.sunrise]  as! Int))
        self.sunset = Date(timeIntervalSince1970: TimeInterval(sysDic[Keys.sunset]  as! Int))
        
        
        self.description = weatherDic[Keys.main] as! String
        self.verboseDescription = weatherDic[Keys.verboseDescription] as! String
        let iconUrlString = "\(Weather.iconRelativePath)\(weatherDic[Keys.iconPath] as! String).png"
        self.iconUrl = URL(string: iconUrlString)!
        
        let mainDic = dictionary[Keys.main] as! [String: Any]
        self.temperature = mainDic[Keys.temperature] as! Float
        self.maxTemperature = mainDic[Keys.maxTemperature] as! Float
        self.minTemperature = mainDic[Keys.minTemperature] as! Float
        self.pressure = mainDic[Keys.pressure] as! Int
        self.humidity = mainDic[Keys.humidity] as! Int
        self.visibility = dictionary[Keys.visibility] as? Int
    }
    
    init(dictionary: [String: Any], cityDictionary: [String: Any]) {
        
        let locId = String(describing: cityDictionary[Keys.identifier] as! Int)
        let locCountryCode = cityDictionary[Keys.locationCountryCode] as! String
        let locName = cityDictionary[Keys.locationName] as! String
        let locCoord = cityDictionary[Keys.locationCoordinates] as! [String: Any]
        let locLat = locCoord[Keys.locationLatitude] as! Float
        let locLong = locCoord[Keys.locationLongitude] as! Float
        
        self.location = Location(identifier: locId, countryCode: locCountryCode, name: locName, latitude: locLat, longitude: locLong)
        
        let windDic = dictionary[Keys.wind] as! [String: Any]
        let speed = windDic[Keys.windSpeedSpeed] as! Float
        let degrees = windDic[Keys.windSpeedDegrees] as! Int
        self.wind = Wind(speed: speed, degrees: degrees)
        
        let weatherArray = dictionary[Keys.weather] as! [[String: Any]]
        let weatherDic = weatherArray.first!
        self.identifier = String(describing: weatherDic[Keys.identifier] as! Int)
        self.date = Date(timeIntervalSince1970: TimeInterval(dictionary[Keys.currentDate]  as! Int))
        self.sunrise = nil
        self.sunset = nil
        
        self.description = weatherDic[Keys.main] as! String
        self.verboseDescription = weatherDic[Keys.verboseDescription] as! String
        let iconUrlString = "\(Weather.iconRelativePath)\(weatherDic[Keys.iconPath] as! String).png"
        self.iconUrl = URL(string: iconUrlString)!
        
        let mainDic = dictionary[Keys.main] as! [String: Any]
        self.temperature = mainDic[Keys.temperature] as! Float
        self.maxTemperature = mainDic[Keys.maxTemperature] as! Float
        self.minTemperature = mainDic[Keys.minTemperature] as! Float
        self.pressure = mainDic[Keys.pressure] as! Int
        self.humidity = mainDic[Keys.humidity] as! Int
        self.visibility = nil
    }
}

