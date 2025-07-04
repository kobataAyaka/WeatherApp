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
    
    let seoulId = 1835847
    let tokyoId = 1850147
    let osakaId = 1853908
    let fukuokaId = 1863967

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                Button("서울") {
                    viewStore.send(.cityButtonTouched(seoulId))
                }
                Button("도쿄") {
                    viewStore.send(.cityButtonTouched(tokyoId))
                }
                Button("오사카") {
                    viewStore.send(.cityButtonTouched(osakaId))
                }
                Button("후쿠오카") {
                    viewStore.send(.cityButtonTouched(fukuokaId))
                }
                
                HStack(spacing: 8) {
                    TextField("or 도시명을 영어로 입력하세요", text: viewStore.binding(get: \.city, send: WeatherFeature.Action.cityChanged))
                        .textFieldStyle(.roundedBorder)
//                        .padding()

                    Button("취득") {
                        viewStore.send(.fetchButtonTapped)
                    }
                    .disabled(viewStore.isLoading)
                }

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
            .padding(16)
            .alert(
              store: self.store.scope(
                state: \.$alert,                     // ← $つき
                action: WeatherFeature.Action.alert  // ← 明示
              )
            )

        }
    }
}

