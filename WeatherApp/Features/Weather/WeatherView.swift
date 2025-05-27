//
//  WeatherView.swift
//  WeatherApp
//
//  Created by 小幡綾加 on 5/24/25.
//

import SwiftUI
import ComposableArchitecture

struct WeatherView: View {
    let store: StoreOf<WeatherFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                TextField("都市名を入力", text: viewStore.binding(get: \.city, send: WeatherFeature.Action.cityChanged))
                    .textFieldStyle(.roundedBorder)
                    .padding()

                Button("取得") {
                    viewStore.send(.fetchButtonTapped)
                }
                .disabled(viewStore.isLoading)

                if viewStore.isLoading {
                    ProgressView()
                } else if let weather = viewStore.weather {
                    VStack(spacing: 8) {
                        Text("都市: \(weather.name)")
                        Text("気温: \(weather.main.temp, specifier: "%.1f") ℃")
                        Text("天気: \(weather.weather.first?.description ?? "不明")")
                    }
                }
            }
            .alert(
              store: self.store.scope(
                state: \.$alert,                     // ← $つき
                action: WeatherFeature.Action.alert  // ← 明示
              )
            )

        }
    }
}

