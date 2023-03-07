//
//  WeatherManager.swift
//  weather-app
//
//  Created by Hasan Yavuz on 6.03.2023.
//

import Foundation
import Alamofire

struct WeatherManager {
    
    private let API_KEY = "72326e5a41e6d131c051698b5dc8fca6"
    
    func fetchWeather(byCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        let urlString = String(format: path, query, API_KEY)
        
        AF.request(urlString).responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let weatherData):
                completion(.success(weatherData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
