//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 27/03/2023.
//

import Foundation
import Moya
import RxSwift
import RxMoya

public class OpenWeatherService {
    let provider = MoyaProvider<OpenWeatherAPI>(plugins:[
      NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    public init() {}
    
    public func getLocation(q: String) -> Single<LocationResponse> {
        provider.rx.request(.getLocation(q: q)).map(LocationResponse.self)
    }
    
    public func getCurrentWeather(lat: Double, lon: Double, unit: Unit = .standard) -> Single<CurrentWeatherResponse> {
        provider.rx.request(.getCurrentWeather(lat: lat, lon: lon, unit: unit)).map(CurrentWeatherResponse.self)
    }
    
    public func getWeatherForecast(lat: Double, lon: Double, unit: Unit = .standard) -> Single<WeatherForecastResponse> {
        provider.rx.request(.get5DayForecast(lat: lat, lon: lon, unit: unit)).map(WeatherForecastResponse.self)
    }
}
