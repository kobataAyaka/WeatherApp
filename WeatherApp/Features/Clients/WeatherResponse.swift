//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by 小幡綾加 on 5/24/25.
//

import Foundation

struct WeatherResponse: Equatable, Decodable {
    struct Weather: Equatable, Decodable {
        let description: String
    }

    struct Main: Equatable, Decodable {
        let temp: Double
        let humidity: Int
    }

    let name: String
    let weather: [Weather]
    let main: Main
}
