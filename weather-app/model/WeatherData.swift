//
//  WeatherData.swift
//  weather-app
//
//  Created by Hasan Yavuz on 6.03.2023.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Decodable {
    let temp: Double
}
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}
