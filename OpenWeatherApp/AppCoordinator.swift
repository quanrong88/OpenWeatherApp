//
//  AppCoordinator.swift
//  OpenWeatherApp
//
//  Created by Tạ Minh Quân on 27/03/2023.
//

import Foundation
import DataAccess
import UIKit
import BusinessLogic
import RxSwift

public class AppCoordinator {
    let apiService: OpenWeatherService
    private var bag = DisposeBag()
    
    public var window: UIWindow
    let navigationController: UINavigationController
    
    public init(window: UIWindow) {
        self.window = window
        self.apiService = OpenWeatherService()
        
        let mainViewModel = MainViewModel(apiService: apiService)
        let mainVC = MainVC(viewModel: mainViewModel)
        
        self.navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .purple
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        
        mainViewModel.navigate.subscribe(onNext: {
            let forecastVM = ForecastViewModel(apiService: self.apiService)
            let forecastVC = ForecastVC(viewModel: forecastVM)
            self.navigationController.pushViewController(forecastVC, animated: true)
        })
        .disposed(by: bag)
        
    }
    
    public func start() {
        window.rootViewController = navigationController
    }
    
    public func finish() {
    }
}
