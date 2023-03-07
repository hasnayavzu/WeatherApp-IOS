//
//  ViewController.swift
//  weather-app
//
//  Created by Hasan Yavuz on 6.03.2023.
//

import UIKit
import SkeletonView

class WeatherViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
        fetchWeather()
        // weatherManager.fetchWeather(byCity: "Istanbul")
    }
    
    private func fetchWeather() {
        
        weatherManager.fetchWeather(byCity: "Istanbul") { [weak self] (result) in
            guard let this = self else {return}
            switch result {
            case .success(let weatherData):
                this.updateView(with: weatherData)
            case .failure(let error):
                print("error here: \(error)")
            }
        }
    }
    
    private func updateView(with data: WeatherData) {
        hideAnimation()
        conditionLabel.text = data.weather.first?.description
        temperatureLabel.text = data.main.temp.toString().appending("°C")
        navigationItem.title = data.name
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

    @IBAction func addLocationButtonTapped(_ sender: Any) {
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
    }
    
}

