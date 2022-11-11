//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherBrick

class WeatherBrickTests: XCTestCase, UserLocationServiceDelegate {
    func didRecieveLocation(coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
        exp?.fulfill()
    }

    func didRecieveError(error: Error) {
        self.locationError = error
        exp?.fulfill()
    }

    var exp: XCTestExpectation?
    var coordinates: CLLocationCoordinate2D?
    var errorString: String?
    var locationError: Error?
    var receivedWeather: OpenWeatherAPIModel?
    var userLocationService: UserLocationService!
    var weatherService: WeatherService!
    var locationManager: MockLocationManager!
    var authorizationStatus: CLAuthorizationStatus!

    override func setUp() {
        locationManager = MockLocationManager()
        userLocationService = UserLocationService(locationManager: locationManager)
        weatherService = WeatherService(urlSession: URLSessionMock())
        authorizationStatus = MockLocationManager().getAuthorizationStatus()
        super.setUp()
    }

    override func tearDown() {
        locationManager = nil
        userLocationService = nil
        weatherService = nil
        super.tearDown()
    }

    func testReceivedCoordinates() throws {
        userLocationService.userLocationServiceDelegate = self
        let customCoordinates = [CLLocation(latitude: 59.3317,
                                            longitude: -122.0325086)]
        locationManager.location = .success(customCoordinates)
        exp = expectation(description: "Location")
        userLocationService.requestLocationPermission()
        waitForExpectations(timeout: 2)
        let result = try XCTUnwrap(coordinates)
        XCTAssertNotNil(result)
    }

    func testReceivedCoordinatesDeniedError() throws {
        userLocationService.userLocationServiceDelegate = self
        if authorizationStatus == .denied ||
            authorizationStatus == .restricted ||
            authorizationStatus == .notDetermined {
            locationManager.location = .failure(CLError(.denied))
            exp = expectation(description: "Location")
            userLocationService.requestLocationPermission()
            waitForExpectations(timeout: 2)
            let result = try XCTUnwrap(locationError)
            XCTAssertNotNil(result)
        }
    }

    func testReceivedCoordinatesLocationUnknownError() throws {
        userLocationService.userLocationServiceDelegate = self
        locationManager.location = .failure(CLError(.locationUnknown))
        exp = expectation(description: "Location")
        userLocationService.requestLocationPermission()
        waitForExpectations(timeout: 2)
        let result = try XCTUnwrap(locationError)
        XCTAssertNotNil(result)
    }

    func testReceivedWeather() throws {
        let exp = expectation(description: "URL")
        weatherService.requestWeather(lat: 59.3317, lon: -122.0325086, completion: { data in
            switch data {
            case .success(let weather):
                self.receivedWeather = weather
                exp.fulfill()

                XCTAssertNotNil(weather)
                XCTAssertEqual(weather.name, "Fort Nelson")
                XCTAssertEqual(weather.main.temp, 16.99)
                XCTAssertEqual(weather.sys.country, "CA")
                XCTAssertEqual(weather.weather.first?.main, "Clear")
                XCTAssertEqual(weather.wind.speed, 1.47)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        waitForExpectations(timeout: 1)
    }
}
