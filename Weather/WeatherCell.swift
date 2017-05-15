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
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cityNameLabel.text = nil
        self.descriptionLabel.text = nil
        self.verboseDescriptionLabel.text = nil
        self.windSpeedLabel.text = nil
        self.humidityLabel.text = nil
        self.pressureLabel.text = nil
        self.dateLabel.text = nil
        self.temperatureLabel.text = nil
        self.highTemperatureLabel.text = nil
        self.lowTemperatureLabel.text = nil
        self.iconImageView.image = nil
    }
}
