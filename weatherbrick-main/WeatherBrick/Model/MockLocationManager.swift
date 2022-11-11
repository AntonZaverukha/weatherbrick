//
//  MockLocationManager.swift
//  WeatherBrick
//
//  Created by Антон Заверуха on 18.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

class MockLocationManager: LocationManager {
    var location: Result<[CLLocation], CLError>!
    var delegate: CLLocationManagerDelegate?

    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return .denied
    }

    func isLocationServicesEnabled() -> Bool {
        return true
    }

    func requestWhenInUseAuthorization() {
    }

    func requestLocation() {
        switch location {
        case .success(let coordinates):
            delegate?.locationManager?(CLLocationManager(), didUpdateLocations: coordinates)
        case .failure(let error):
            delegate?.locationManager?(CLLocationManager(), didFailWithError: error)
        default:
            break
        }
    }
}
