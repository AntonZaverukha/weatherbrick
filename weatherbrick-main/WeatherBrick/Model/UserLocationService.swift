//
//  UserLocationCheck.swift
//  WeatherBrick
//
//  Created by Антон Заверуха on 03.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import CoreLocation

enum ErrorStrings: String {
    case locationUnknown = "k_location_unknown"
    case permissionDenied = "k_permission_denied"
    case otherError = "k_unknown_error"

    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self.rawValue, comment: comment ?? "")
    }
}

protocol LocationManager {
    func requestWhenInUseAuthorization()
    func requestLocation()

    var delegate: CLLocationManagerDelegate? { get set }
}

class UserLocationService: NSObject {
    var userLocationServiceDelegate: UserLocationServiceDelegate?
    var locManager: LocationManager

    init(locationManager: LocationManager) {
        self.locManager = locationManager
    }

    func requestLocationPermission() {
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
        locManager.requestLocation()
    }
}

extension UserLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        self.userLocationServiceDelegate?.didRecieveLocation(coordinates: currentLocation.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.userLocationServiceDelegate?.didRecieveError(error: error)
    }
}

extension CLLocationManager: LocationManager {
}
