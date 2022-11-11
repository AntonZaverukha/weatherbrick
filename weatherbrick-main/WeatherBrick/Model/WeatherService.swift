//
//  WeatherService.swift
//  WeatherBrick
//
//  Created by Антон Заверуха on 05.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherService {
    enum CustomServiceErrors: Error {
        case failedRequest(error: Error)
        case errorDecode
        case uknownError
    }

    var urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

    func buildUrl(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) -> URL {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            return URL(string: "Invalid API Key")!
        }
        let apiKey = "appid=\(key)"
        let coordinatesPart = "lat=\(lat)&lon=\(lon)"
        let units = "units=metric"
        let openWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?\(coordinatesPart)&\(apiKey)&\(units)"
        guard let url = URL(string: openWeatherUrl) else { return URL(string: "Invalid URL")! }
        return url
    }

    func requestWeather(lat: CLLocationDegrees,
                        lon: CLLocationDegrees,
                        completion: @escaping (Result<OpenWeatherAPIModel, CustomServiceErrors>) -> Void) {
        urlSession.dataTask(with: buildUrl(lat, lon)) { data, _, error in
            if error != nil {
                guard let unwrappedError = error else { return }
                completion(.failure(.failedRequest(error: unwrappedError)))
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let info = try decoder.decode(OpenWeatherAPIModel.self, from: data)
                    completion(.success(info))
                } catch {
                    completion(.failure(.errorDecode))
                }
            } else {
                completion(.failure(.uknownError))
            }
        }.resume()
    }
}

extension URLSession: URLSessionProtocol {
}
