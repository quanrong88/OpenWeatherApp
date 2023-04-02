import XCTest
@testable import BusinessLogic
import DataAccess
import RxSwift

final class BusinessLogicTests: XCTestCase {
    let apiService = OpenWeatherService()
    var disposeBag = DisposeBag()
    func testMainViewModel() {
        let viewModel = MainViewModel(apiService: apiService)
        viewModel.actionInput.onNext(.search(word: "ha noi"))
        let exp = expectation(description: "Load API")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let viewModel2 = ForecastViewModel(apiService: self.apiService)
            viewModel2.actionInput.onNext(.loadData)
            viewModel2.forecastCellModelSubject.subscribe({ value in
                print(value)
            })
            .disposed(by: self.disposeBag)
        }
        waitForExpectations(timeout: 10)
    }
}
