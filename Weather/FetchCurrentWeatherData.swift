//
//  FetchCurrentWeatherData.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/14/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

final class FetchCurrentWeatherData: FetchWeatherData {
    
    // MARK: - Properties
    
    private var completionHandler: (Weather?, Error?) -> ()
    
    // MARK: - Lifecycle
    
    convenience init(zipCode: String, completion: @escaping (Weather?, Error?) -> ()) {
        let queryItem = URLQueryItem(name: "zip", value: zipCode)
        self.init(queryItems: [queryItem], completion: completion)
    }
    
    convenience init(cityName: String, completion: @escaping (Weather?, Error?) -> ()) {
        let queryItem = URLQueryItem(name: "q", value: cityName)
        self.init(queryItems: [queryItem], completion: completion)
    }
    
    private init(queryItems: [URLQueryItem], completion: @escaping (Weather?, Error?) -> ()) {
        self.completionHandler = completion
        super.init(path: "weather", queryItems: queryItems)
    }
    
    override func didFinishDataTaskWithData(_ data: FetchWeatherData.ResponseData) {
        
        guard let jsonData = data.data else {
            
            if let error = data.error {
                completionHandler(nil , error)
            }
            
            completionHandler(nil, nil)
            return
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                completionHandler(nil, nil)
                return
            }
            
            let weatherObject = Weather(dictionary: json)
            
            completionHandler(weatherObject, nil)
        } catch {
            // json not parsable
            completionHandler(nil, nil)
        }
    }
}
