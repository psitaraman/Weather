//
//  DateFormatter+Utilities.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/15/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    convenience init(format: String, locale: Locale = Locale(identifier: "en_US_POSIX")) {
        self.init()
        self.dateFormat = format
        self.locale = locale
    }
}
