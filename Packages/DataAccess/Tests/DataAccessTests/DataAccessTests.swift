import XCTest
@testable import DataAccess
import Moya
import RxSwift

final class DataAccessTests: XCTestCase {
    let apiService = OpenWeatherService()
    var disposeBag = DisposeBag()
    
    func testLoadLocation() {
        let exp = expectation(description: "Load API")
        apiService.getLocation(q: "Ha Noi")
            .subscribe({ resp in
                print(resp)
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 5)
    }
    
    func testLoadCurrentWeather() {
        let exp = expectation(description: "Load API")
        apiService.getCurrentWeather(lat: 21.0294498, lon: 105.8544441)
            .subscribe({ resp in
                print(resp)
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 5)
    }
    
    func testLoadWeatherForecast() {
        let exp = expectation(description: "Load API")
        apiService.getWeatherForecast(lat: 21.0294498, lon: 105.8544441)
            .subscribe({ resp in
                print(resp)
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 5)
    }
    
    func testLoadWeatherByName() {
        let exp = expectation(description: "Load API")
        apiService.getLocation(q: "Hanoi")
            .map({ element in
                return element.first!
            })
            .flatMap { value -> Single<CurrentWeatherResponse> in
                return self.apiService.getCurrentWeather(lat: value.lat, lon: value.lon, unit: .metric)
            }
        //Cast to observable
//            .asObservable()
//            .subscribe(onNext: { value in
//                print(value)
//                exp.fulfill()
//            })
        //Old implement still correct
//            .subscribe({ value in
//                if case .success(let result) = value {
//                    print(result.main)
//                }
//
//                if case .failure(let error) = value {
//                    print(error)
//                }
//                exp.fulfill()
//
//            })
        
            .subscribe { event in
                switch event {
                case .success(let json):
                    print("JSON: ", json)
                case .failure(let error):
                    print("Error: ", error)
                }
                exp.fulfill()
            }
        
            .disposed(by: disposeBag)
           
        waitForExpectations(timeout: 5)
    }
}
