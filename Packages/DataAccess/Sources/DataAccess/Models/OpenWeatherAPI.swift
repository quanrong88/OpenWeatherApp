//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 27/03/2023.
//

import Foundation
import Moya

public enum Unit: String {
    case standard = "standard"
    case metric = "metric"
    
    public func displaySuffix() -> String {
        switch self {
        case .standard:
            return "°F"
        case .metric:
            return "°C"
        }
    }
}

enum OpenWeatherAPI {
    case getLocation(q: String)
    case getCurrentWeather(lat: Double, lon: Double, unit: Unit)
    case get5DayForecast(lat: Double, lon: Double, unit: Unit)
}

extension OpenWeatherAPI: TargetType {
    var baseURL: URL {
      return URL(string: "http://api.openweathermap.org")!
    }
    
    var path: String {
        switch self {
        case .getLocation:
            return "/geo/1.0/direct"
        case .getCurrentWeather:
            return "/data/2.5/weather"
        case .get5DayForecast:
            return "/data/2.5/forecast"
        }
    }
    
    var method: Moya.Method {
      return .get
    }
    
    var headers: [String : String]? {
      return ["Content-type": "application/json"]
    }
    
    var task: Task {
        switch self {
        case .getLocation(q: let q):
            let param: [String: Any] = [
              "q": q,
              "appid": Constants.APIKey
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .getCurrentWeather(lat: let lat, lon: let lon, unit: let unit):
            let param: [String: Any] = [
              "lat": lat,
              "lon": lon,
              "units": unit.rawValue,
              "appid": Constants.APIKey
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .get5DayForecast(lat: let lat, lon: let lon, unit: let unit):
            let param: [String: Any] = [
              "lat": lat,
              "lon": lon,
              "units": unit.rawValue,
              "appid": Constants.APIKey
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
}

// MARK: - LocationResponseElement
public struct LocationResponseElement: Codable {
    public let name: String
    public let localNames: [String: String]
    public let lat, lon: Double
    public let country: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country
    }
}

public typealias LocationResponse = [LocationResponseElement]

// MARK: - CurrentWeatherResponse
public struct CurrentWeatherResponse: Codable {
    
    public let weather: [Weather]
    
    public let main: Main
}

public struct Clouds: Codable {
    public let all: Int
}

public struct Coord: Codable {
    public let lon, lat: Double
}

public struct Main: Codable {
    public let temp: Double
    public let humidity: Int

}

public struct Sys: Codable {
    public let type, id: Int
    public let country: String
    public let sunrise, sunset: Int
}

public struct Weather: Codable {
    public let id: Int
    public let main, description, icon: String
}

public struct Wind: Codable {
    public let speed: Double
    public let deg: Int
    public let gust: Double
}

// MARK: - WeatherForecastResponse
public struct WeatherForecastResponse: Codable {
    public let cod: String
    public let message, cnt: Int
    public let list: [List]
    public let city: City
}

public struct City: Codable {
    public let id: Int
    public let name: String
    public let coord: Coord
    public let country: String
    public let population, timezone, sunrise, sunset: Int
}

public struct List: Codable {
    public let dt: Int
    public let main: MainClass
    public let weather: [Weather]
    public let clouds: Clouds
    public let wind: Wind
    public let visibility: Int
    public let pop: Double
    public let sys: ForecastSys
    public let dtTxt: String
    public let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

public struct MainClass: Codable {
    public let temp, feelsLike, tempMin, tempMax: Double
    public let pressure, seaLevel, grndLevel, humidity: Int
    public let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

public struct Rain: Codable {
    public let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

public struct ForecastSys: Codable {
    public let pod: String
}
