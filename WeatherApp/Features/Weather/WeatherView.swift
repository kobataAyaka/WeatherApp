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
                TextField("도시명을 영어로 입력하세요", text: viewStore.binding(get: \.city, send: WeatherFeature.Action.cityChanged))
                    .textFieldStyle(.roundedBorder)
                    .padding()

                Button("취득") {
                    viewStore.send(.fetchButtonTapped)
                }
                .disabled(viewStore.isLoading)

                if viewStore.isLoading {
                    ProgressView()
                } else if let weather = viewStore.weather {
                    VStack(spacing: 8) {
                        Text("도시: \(weather.name)")
                        Text("기온: \(weather.main.temp, specifier: "%.1f") ℃")
                        Text("날씨: \(weather.weather.first?.description ?? "불명")")
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

