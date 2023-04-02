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

public class MainViewModel {
    
    public enum MainViewError: Error {
        case locationNotFound
    }
    
    public enum Action {
        case search(word: String)
        case switchUnit
        case clear
        case navigateDetail
    }
    let apiService: OpenWeatherService
    private var bag = DisposeBag()
    
    public let actionInput = PublishSubject<Action>()
    
    public let tempatureValueSubject = BehaviorSubject<String>(value: "---")
    public let humilityValueSubject = BehaviorSubject<String>(value: "---")
    public let nameValueSubject =  BehaviorSubject<String>(value: "Weather")
    public let iconValueSubject = BehaviorSubject<String>(value: "")
    public let navigateDetailEnable = BehaviorSubject<Bool>(value: false)
    public let navigate = PublishSubject<Void>()
    
    public init(apiService: OpenWeatherService) {
        self.apiService = apiService
        
        actionInput
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let `self` = self else { return }
                self.handleAction(action: value)
            })
            .disposed(by: bag)
    }
    
    func handleAction(action: Action) {
        switch action {
        case .search(word: let q):
            if !q.isEmpty {
                AppState.shared.q = q
            }
            
            search()
        case .switchUnit:
            if AppState.shared.unit == .standard {
                AppState.shared.unit = .metric
            } else {
                AppState.shared.unit = .standard
            }
            
            search()
        case .clear:
            tempatureValueSubject.onNext("---")
            humilityValueSubject.onNext("---")
            nameValueSubject.onNext("Weather")
            iconValueSubject.onNext("")
            navigateDetailEnable.onNext(false)
            AppState.shared.clear()
        case .navigateDetail:
            navigate.onNext(())
        }
    }
    
    func search() {
        guard !AppState.shared.q.isEmpty else {
            
            return
        }
        apiService.getLocation(q: AppState.shared.q)
            .map({ value in
                guard let location = value.first else {
                    throw MainViewError.locationNotFound
                }
                return location
            })
            .flatMap { location in
                self.nameValueSubject.onNext(location.name)
                AppState.shared.lat = location.lat
                AppState.shared.lon = location.lon
                return self.apiService.getCurrentWeather(lat: location.lat, lon: location.lon, unit: AppState.shared.unit)
            }
            .subscribe({ value in
                if case .success(let result) = value {
                    let unit = AppState.shared.unit

                    let displayTempature = "Tempature: \(result.main.temp)\(unit.displaySuffix())"
                    let diplayHumidity = "Humidity: \(result.main.humidity)"
                    
                    if let iconWeather = result.weather.first?.icon {
                        let iconUrl = "https://openweathermap.org/img/wn/\(iconWeather)@2x.png"
                        self.iconValueSubject.onNext(iconUrl)
                    } else {
                        self.iconValueSubject.onNext("")
                    }
                    self.tempatureValueSubject.onNext(displayTempature)
                    self.humilityValueSubject.onNext(diplayHumidity)
                    
                    self.navigateDetailEnable.onNext(true)
                } else {
                    self.handleAction(action: .clear)
                }
            })
            .disposed(by: bag)
            
    }
    
}
