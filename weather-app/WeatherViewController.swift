//
//  ViewController.swift
//  weather-app
//
//  Created by Hasan Yavuz on 6.03.2023.
//

import UIKit
import SkeletonView

protocol WeatherViewControllerDelegate: class {
    func didUpdateWeatherFromSearch(model: WeatherModel)
}

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
            case .success(let model):
                this.updateView(with: model)
            case .failure(let error):
                print("error here: \(error)")
            }
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
    }
    
}

extension WeatherViewController: WeatherViewControllerDelegate {
    func didUpdateWeatherFromSearch(model: WeatherModel) {
        <#code#>
    }
}
