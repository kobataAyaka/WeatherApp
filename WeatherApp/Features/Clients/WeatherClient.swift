//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by 小幡綾加 on 5/24/25.
//

import Foundation
import ComposableArchitecture

let apiKey = "YOUR_API_KEY" //OpenWeather에 로그인해서 취득

struct WeatherClient {
    var fetchWeather: (String) async throws -> WeatherResponse
    var fetchWeatherById: (Int) async throws -> WeatherResponse
}

extension WeatherClient: DependencyKey {
    static let liveValue = WeatherClient(
        fetchWeather: { city in
            let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)&units=metric&lang=kr")!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        },
        fetchWeatherById: { cityId in
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=\(apiKey)&units=metric&lang=kr")!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        }
    )
}

extension DependencyValues {
    var weatherClient: WeatherClient {
        get { self[WeatherClient.self] }
        set { self[WeatherClient.self] = newValue }
    }
}
