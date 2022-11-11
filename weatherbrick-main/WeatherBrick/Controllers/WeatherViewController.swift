import UIKit
import CoreLocation

protocol UserLocationServiceDelegate: AnyObject {
    func didRecieveLocation(coordinates: CLLocationCoordinate2D)
    func didRecieveError(error: Error)
}

class WeatherViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconLocationImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var iconSearchImageView: UIImageView!
    let userLocationService = UserLocationService(locationManager: CLLocationManager())
    var passedCoordinates: CLLocationCoordinate2D?
    var weatherService = WeatherService(urlSession: URLSession.shared)
    var brickImageSelection = BrickImageSelection()
    var openWeatherApiModel: OpenWeatherAPIModel?
    var gradientButtonBackground = ButtonBackground()
    var brickImageAnimations = BrickImageAnimations()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        userLocationService.userLocationServiceDelegate = self
        userLocationService.requestLocationPermission()
        gradientButtonBackground.gradientBack(button: infoButton)
        infoButton.layer.cornerRadius = 17
        infoButton.clipsToBounds = true
        addImageViewSwipeGestureRecognizer()
        activityIndicator.isHidden = true
    }
}

extension WeatherViewController {
    func addImageViewSwipeGestureRecognizer() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                              action: #selector(imageSwiped(swipeGestureRecognizer:)))
        swipeGestureRecognizer.direction = .down
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(swipeGestureRecognizer)
    }

    @objc func imageSwiped(swipeGestureRecognizer: UISwipeGestureRecognizer) {
        guard let swipedImage = swipeGestureRecognizer.view as? UIImageView else { return }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        swipedImage.imageDownAndUp()
        userLocationService.requestLocationPermission()
    }
}

extension WeatherViewController: UserLocationServiceDelegate {
    func didRecieveLocation(coordinates: CLLocationCoordinate2D) {
        passedCoordinates = coordinates
        requestWeatherData()
    }

    func didRecieveError(error: Error) {
        self.errorLabel.isHidden = false
        if let managerError = error as? CLError {
            switch managerError {
            case CLError.locationUnknown:
                self.errorLabel.text = ErrorStrings.locationUnknown.localized()
            case CLError.denied:
                self.errorLabel.text = ErrorStrings.permissionDenied.localized()
            default:
                self.errorLabel.text = ErrorStrings.otherError.localized()
            }
        }
    }
}

extension WeatherViewController {
    func showInfo() {
        self.infoButton.isHidden = false
        self.tempLabel.isHidden = false
        self.conditionsLabel.isHidden = false
        self.locationLabel.isHidden = false
        self.iconLocationImageView.isHidden = false
        self.iconSearchImageView.isHidden = false
    }

    func showError(error: Error) {
        self.errorLabel.isHidden = false
        self.errorLabel.text = "\(error).\n Please check your Internet connection"
    }

    func setUpView(_ weather: OpenWeatherAPIModel) {
        self.showInfo()
        self.tempLabel.text = "\(Int(weather.main.temp))" + "°"
        self.locationLabel.text = "\(weather.name), \(weather.sys.country)"
        guard let weatherConditions = weather.weather.first else { return }
        self.conditionsLabel.text = "\(weatherConditions.main.lowercased())"
        imageView.isHidden = false
        imageView.image = brickImageSelection.brickImageSelection(weatherConditions.main, weather, imageView: imageView)
        if weather.wind.speed >= 5.0 {
            brickImageAnimations.animateBrickImageView(imageView: imageView, brickImage: imageView.image!)
        }
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }

    func requestWeatherData() {
        guard let unwrappedCoordinates = passedCoordinates else { return }
        weatherService.requestWeather(lat: unwrappedCoordinates.latitude,
                                      lon: unwrappedCoordinates.longitude,
                                      completion: { success in
                                        switch success {
                                        case .failure(let error):
                                            DispatchQueue.main.async {
                                                self.showError(error: error)
                                            }
                                        case .success(let data):
                                            DispatchQueue.main.async {
                                                self.setUpView(data)
                                            }
                                        }
        })
    }
}
