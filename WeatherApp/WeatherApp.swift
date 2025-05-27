//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by 小幡綾加 on 5/24/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(
                store: Store(
                    initialState: WeatherFeature.State(),
                    reducer: {
                        WeatherFeature()
                    }
                )
            )
        }
    }
}
