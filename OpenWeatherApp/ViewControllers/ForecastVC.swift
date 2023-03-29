//
//  ForecastVC.swift
//  OpenWeatherApp
//
//  Created by Tạ Minh Quân on 27/03/2023.
//

import UIKit
import RxSwift
import RxCocoa
import BusinessLogic

class ForecastVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: ForecastViewModel
    var bag = DisposeBag()
    var dataSource: [ForecastCellModel] = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ForecastVC", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindingViewModel()
        viewModel.actionInput.onNext(.loadData)
        
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "ForecastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ForecastCell")
        tableView.dataSource = self
        tableView.rowHeight = 96
    }
    
    func bindingViewModel() {
        viewModel.forecastCellModelSubject
            .subscribe(onNext: {value in
                self.dataSource = value
                self.tableView.reloadData()
            })
            .disposed(by: bag)
    }

}

extension ForecastVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        let cellModel = dataSource[indexPath.row]
        cell.updateCell(cellModel)
        return cell
    }
}


