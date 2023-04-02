//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 27/03/2023.
//

import Foundation
import RxSwift
import DataAccess
import RxCocoa

public class ForecastViewModel {
    
    public enum Action {
        case loadData
    }
    
    let apiService: OpenWeatherService
    private var bag = DisposeBag()
    
    public let actionInput = PublishSubject<Action>()
    
    public var forecastCellModelSubject = BehaviorSubject<[ForecastCellModel]>(value: [])
    
    public init(apiService: OpenWeatherService) {
        self.apiService = apiService
        
        actionInput
            .subscribe(onNext: { [weak self] value in
                guard let `self` = self else { return }
                self.handleAction(action: value)
            })
            .disposed(by: bag)
    }
    
    func handleAction(action: Action) {
        switch action {
        case .loadData:
            loadData()
        }
    }
    
    func loadData() {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm dd/MM/YYYY"
        apiService.getWeatherForecast(lat: AppState.shared.lat, lon: AppState.shared.lon, unit: AppState.shared.unit)
            .map { item -> [ForecastCellModel] in
                return item.list.map { element -> ForecastCellModel in
                    let displayTempature = "Tempature: \(element.main.temp)\(AppState.shared.unit.displaySuffix())"
                    let diplayHumidity = "Humidity: \(element.main.humidity)"
                    var iconImage  = ""
                    if let iconWeather = element.weather.first?.icon {
                        iconImage = "https://openweathermap.org/img/wn/\(iconWeather)@2x.png"
                    }
                    let date = Date(timeIntervalSince1970: TimeInterval(element.dt))
                    let dateString = dayTimePeriodFormatter.string(from: date)
                    return ForecastCellModel(displayTempature: displayTempature, displayHumidity: diplayHumidity, displayIcon: iconImage, displayDateTime: dateString)
                }
            }
            .subscribe({ value in
                if case .success(let result) = value {
                    self.forecastCellModelSubject.onNext(result)
                }
            })
            .disposed(by: bag)
    }
}
