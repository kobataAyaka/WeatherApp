//
//  WeatherFeature.swift
//  WeatherApp
//
//  Created by 小幡綾加 on 5/24/25.
//

import ComposableArchitecture
import SwiftUI

struct WeatherFeature: Reducer {
    struct State: Equatable {
        var city: String = ""
        var weather: WeatherResponse?
        var isLoading: Bool = false
        @PresentationState var alert: AlertState<Action.Alert>?
    }
    
    enum Action: Equatable {
        case cityChanged(String)
        case fetchButtonTapped
        case fetchWeatherResponse(Result<WeatherResponse, WeatherError>)
        case dismissAlert
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case okButtonTapped
        }
    }
    
    enum WeatherError: Error, Equatable {
        case decodingError
        case networkError(String)
        case unknown
    }
    
    @Dependency(\.weatherClient) var weatherClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .cityChanged(city):
            state.city = city
            return .none
            
        case .fetchButtonTapped:
            state.isLoading = true
            state.weather = nil
            return .run { [city = state.city] send in
                do {
                    let weather = try await weatherClient.fetchWeather(city)
                    await send(.fetchWeatherResponse(.success(weather)))
                } catch {
                    let weatherError: WeatherError
                    if let decodingError = error as? DecodingError {
                        weatherError = .decodingError
                    } else {
                        weatherError = .networkError(error.localizedDescription)
                    }
                    await send(.fetchWeatherResponse(.failure(weatherError)))
                }
            }
            
        case let .fetchWeatherResponse(.success(weather)):
            state.isLoading = false
            state.weather = weather
            return .none
            
        case .fetchWeatherResponse(.failure):
            state.isLoading = false
            state.alert = AlertState {
                TextState("通信エラー")
            } actions: {
                ButtonState(action: Action.Alert.okButtonTapped) {
                    TextState("OK")
                }
            }
            return .none
            
        case .dismissAlert:
            state.alert = nil
            return .none
        case .alert(.presented(.okButtonTapped)):
            state.alert = nil
            return .none
        case .alert(.dismiss):
            state.alert = nil
            return .none
        }
    }
}
