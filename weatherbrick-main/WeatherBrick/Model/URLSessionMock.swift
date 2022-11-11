//
//  URLSessionMock.swift
//  WeatherBrick
//
//  Created by Anton on 23.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

class DataTaskMock: URLSessionDataTask {
    override func resume() { }
}

class URLSessionMock: URLSessionProtocol {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    var data: Data? = """
    {
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "description": "clear sky",
          "icon": "01n"
        }
      ],
      "base": "stations",
      "main": {
        "temp": 16.99,
        "feels_like": 16.52,
        "temp_min": 16.99,
        "temp_max": 16.99,
        "pressure": 1011,
        "humidity": 68,
        "sea_level": 1011,
        "grnd_level": 929
      },
      "visibility": 10000,
      "wind": {
        "speed": 1.47,
        "deg": 132,
        "gust": 2.17
      },
      "clouds": {
        "all": 4
      },
      "dt": 1661417206,
      "sys": {
        "country": "CA",
        "sunrise": 1661431760,
        "sunset": 1661484687
      },
      "timezone": -25200,
      "id": 5955902,
      "name": "Fort Nelson",
      "cod": 200
    }
 """.data(using: .utf8)

    var response: URLResponse?
    var error: Error?

    func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        defer { completionHandler(data, nil, error) }
        return DataTaskMock()
    }
}
