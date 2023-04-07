//
//  ViewController.swift
//  weather-app
//
//  Created by Hasan Yavuz on 6.03.2023.
//

import UIKit
import SkeletonView
import CoreLocation

protocol WeatherViewControllerDelegate: AnyObject {
    func didUpdateWeatherFromSearch(model: WeatherModel)
}

class WeatherViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherManager = WeatherManager()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeather(byCity: "Istanbul")
    }
    
    private func fetchWeather(byLocation location: CLLocation) {
        showAnimation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchWeather(lat: lat, lon: lon) { [weak self] (result) in
            guard let this = self else { return }
            this.handleResult(result)
        }
    }
    
    private func fetchWeather(byCity city: String) {
        showAnimation()
        weatherManager.fetchWeather(byCity: city) { [weak self] (result) in
            guard let this = self else {return}
            this.handleResult(result)
        }
    }
    
    private func handleResult(_ result: Result<WeatherModel, Error>) {
        switch result {
        case .success(let model):
            updateView(with: model)
        case .failure(let error):
            print("error here: \(error)")
        }
    }
    
    private func updateView(with model: WeatherModel) {
        hideAnimation()
        
        conditionLabel.text = model.conditionDescription
        temperatureLabel.text = model.temp.toString().appending("°C")
        navigationItem.title = model.countryName
        conditionImageView.image = UIImage(named: model.conditionImage)
    }
    
    private func hideAnimation() {
        conditionLabel.hideSkeleton()
        conditionImageView.hideSkeleton()
        temperatureLabel.hideSkeleton()
    }
    
    private func showAnimation() {
        conditionImageView.showAnimatedGradientSkeleton()
        conditionLabel.showAnimatedGradientSkeleton()
        temperatureLabel.showAnimatedGradientSkeleton()
    }

    @IBAction func addCityButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showAddCity", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddCity" {
            if let destination = segue.destination as? addCityViewController {
                destination.delegate = self
            }
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        default:
            promptForLocationPermission()
        }
    }
    
    private func promptForLocationPermission() {
        let alertController = UIAlertController(title: "Requires Location Permission", message: "Would you like to enable location permission in settings?", preferredStyle: .alert)
        let enableAction = UIAlertAction(title: "Go to settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(enableAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension WeatherViewController: WeatherViewControllerDelegate {
    
    func didUpdateWeatherFromSearch(model: WeatherModel) {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let this = self else {return}
            this.updateView(with: model)
        })
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            fetchWeather(byLocation: location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
