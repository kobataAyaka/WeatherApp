//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by 小幡綾加 on 5/24/25.
//

import Foundation
import ComposableArchitecture

struct WeatherClient {
    var fetchWeather: (String) async throws -> WeatherResponse
}

extension WeatherClient: DependencyKey {
    static let liveValue = WeatherClient { city in
        let apiKey = "YOUR_API_KEY"
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)&units=metric&lang=ja")!

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}

extension DependencyValues {
    var weatherClient: WeatherClient {
        get { self[WeatherClient.self] }
        set { self[WeatherClient.self] = newValue }
    }
}
