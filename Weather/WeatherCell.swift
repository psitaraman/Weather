//
//  WeatherCell.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/15/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import UIKit

final class WeatherCell: UITableViewCell {

    // MARK: - IBoutlets
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var verboseDescriptionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Properties
    
    static let reuseId = String(describing: WeatherCell.self)
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cityNameLabel.text = nil
        self.descriptionLabel.text = nil
        self.verboseDescriptionLabel.text = nil
        self.windSpeedLabel.text = nil
        self.humidityLabel.text = nil
        self.pressureLabel.text = nil
        self.dateLabel.text = nil
        self.timeLabel.text = nil
        self.temperatureLabel.text = nil
        self.highTemperatureLabel.text = nil
        self.lowTemperatureLabel.text = nil
        self.iconImageView.image = nil
    }
    
    // MARK: - Public
    
    func configureCell(weather: Weather) {
        self.cityNameLabel.text = weather.location.name
        self.descriptionLabel.text = weather.description
        self.verboseDescriptionLabel.text = weather.verboseDescription
        self.windSpeedLabel.text = "\(weather.wind.speed)"
        self.humidityLabel.text = "\(weather.humidity)"
        self.pressureLabel.text = "\(weather.pressure)"
        //self.dateLabel.text = "\(weather.date)"
        //self.timeLabel.text = "\(weather.date)"
        self.temperatureLabel.text = "\(weather.temperature)"
        self.highTemperatureLabel.text = "\(weather.maxTemperature)"
        self.lowTemperatureLabel.text = "\(weather.minTemperature)"
    }
}
