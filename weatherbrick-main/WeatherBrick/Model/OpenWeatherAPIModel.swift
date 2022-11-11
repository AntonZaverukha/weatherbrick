//
//  OpenWeather.swift
//  WeatherBrick
//
//  Created by Антон Заверуха on 05.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

struct OpenWeatherAPIModel: Codable {
    let weather: [Weather]
    let main: WeatherInfo
    let name: String
    let sys: Country
    let wind: Wind
}
