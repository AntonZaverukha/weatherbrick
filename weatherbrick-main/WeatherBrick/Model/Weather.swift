//
//  Weather.swift
//  WeatherBrick
//
//  Created by Антон Заверуха on 05.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}
