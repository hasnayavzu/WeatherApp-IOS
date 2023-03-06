//
//  ViewController.swift
//  weather-app
//
//  Created by Hasan Yavuz on 6.03.2023.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.featherWeather(city: "Istanbul")
    }

    @IBAction func addLocationButtonTapped(_ sender: Any) {
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
    }
    
}

