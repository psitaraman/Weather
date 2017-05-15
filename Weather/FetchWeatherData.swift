//
//  FetchWeatherData.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/13/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

class FetchWeatherData {
    
    // MARK: - Types
    
    private enum Version: Double {
        case v2_5 = 2.5
    }
    
    struct ResponseData {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    struct DownloadData {
        let url: URL?
        let response: URLResponse?
        let error: Error?
    }
    
    // MARK: - Properties
    
    private static let apiKey = "4258d89b965ae3ab12b99474a24f5b8e"
    private static let host = "api.openweathermap.org"
    private static let dataPath = "data"
    private static let scheme = "http"
    
    private let requestUrl: URL
    
    // MARK: - Lifecycle
    
    init(path: String, queryItems: [URLQueryItem]) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = FetchWeatherData.scheme
        urlComponents.host = FetchWeatherData.host
        
        let urlPath = "/\(FetchWeatherData.dataPath)/\(Version.v2_5.rawValue)/\(path)"
        urlComponents.path = urlPath
        
        var urlQueryItems = queryItems
        urlQueryItems.append(URLQueryItem(name: "units", value: "imperial"))
        urlQueryItems.append(URLQueryItem(name: "APPID", value: FetchWeatherData.apiKey))
        urlComponents.queryItems = urlQueryItems
        
        // should crash if url is not valid, url should always be valid
        self.requestUrl = urlComponents.url!
        
        self.executeRequest(asDownloadTask: false)
    }
    
    // MARK: - Abstract methods
    
    func didFinishDataTaskWithData(_ data: ResponseData) {
        // implement in subclass
    }
    
    func didFinishDownloadTaskWithData(_ data: DownloadData) {
        // implement in subclass
    }
    
    // MARK: - Private
    
    private func executeRequest(asDownloadTask: Bool) {
        let urlRequest = URLRequest(url: self.requestUrl)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        guard asDownloadTask else {
            let task = session.dataTask(with: urlRequest) {(data, response, error) in
                let responseData = ResponseData(data: data, response: response, error: error)
                self.didFinishDataTaskWithData(responseData)
            }
            task.resume()
            
            return
        }
        
        let task = session.downloadTask(with: urlRequest) {(url, response, error) in
            let downloadData = DownloadData(url: url, response: response, error: error)
            self.didFinishDownloadTaskWithData(downloadData)
        }
        task.resume()
    }
}
