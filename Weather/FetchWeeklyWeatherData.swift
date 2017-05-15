//
//  FetchWeeklyWeatherData.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/14/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

final class FetchWeeklyWeatherData: FetchWeatherData {
    
    // MARK: - Properties
    
    private var completionHandler: ([Weather], Error?) -> ()
    
    // MARK: - Lifecycle
    
    convenience init(zipCode: String, completion: @escaping ([Weather], Error?) -> ()) {
        let queryItem = URLQueryItem(name: "zip", value: zipCode)
        self.init(queryItems: [queryItem], completion: completion)
    }
    
    convenience init(cityName: String, completion: @escaping ([Weather], Error?) -> ()) {
        let queryItem = URLQueryItem(name: "q", value: cityName)
        self.init(queryItems: [queryItem], completion: completion)
    }
    
    private init(queryItems: [URLQueryItem], completion: @escaping ([Weather], Error?) -> ()) {
        self.completionHandler = completion
        super.init(path: "forecast", queryItems: queryItems)
    }
    
    override func didFinishDataTaskWithData(_ data: FetchWeatherData.ResponseData) {
        
        guard let jsonData = data.data else {
            
            if let error = data.error {
                completionHandler([], error)
            }

            completionHandler([], nil)
            return
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                completionHandler([], nil)
                return
            }
            
            guard let weatherList = json["list"] as? [[String: Any]], let cityDictionary = json["city"] as? [String: Any] else {
                completionHandler([], nil)
                return
            }
            
            var weatherArray = [Weather]()
            for dictionary in weatherList {
                let weatherObject = Weather(dictionary: dictionary, cityDictionary: cityDictionary)
                weatherArray.append(weatherObject)
            }
            
            completionHandler(weatherArray, nil)
        } catch {
            // json not parsable
            completionHandler([], nil)
        }
    }
}
