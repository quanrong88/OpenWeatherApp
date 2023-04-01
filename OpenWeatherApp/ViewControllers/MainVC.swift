//
//  MainVC.swift
//  OpenWeatherApp
//
//  Created by Tạ Minh Quân on 27/03/2023.
//

import UIKit
import BusinessLogic
import RxSwift
import RxCocoa
import Kingfisher

class MainVC: UIViewController {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    private var searchController = UISearchController(searchResultsController: nil)
    let viewModel: MainViewModel
    var bag = DisposeBag()
    var nextButton: UIBarButtonItem!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MainVC", bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton = UIBarButtonItem(title: "Detail", style: .plain, target: self, action: #selector(nextTap))
        setUpSearchController()
        bindingViewModel()
    }
    
    @IBAction func switchButtonTapped(_ sender: UIButton) {
        viewModel.actionInput.onNext(.switchUnit)
    }
    
    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search city"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc func nextTap() {
        viewModel.actionInput.onNext(.navigateDetail)
    }
    
    func bindingViewModel() {
        viewModel.nameValueSubject.asDriver(onErrorJustReturn: "Weather").drive(self.rx.title).disposed(by: bag)
        viewModel.tempatureValueSubject.asDriver(onErrorJustReturn: "---").drive(tempatureLabel.rx.text).disposed(by: bag)
        viewModel.humilityValueSubject.asDriver(onErrorJustReturn: "---").drive(humidityLabel.rx.text).disposed(by: bag)
        viewModel.iconValueSubject.subscribe(onNext: { value in
            guard let url = URL(string: value) else {
                self.iconImageView.image = UIImage(named: "emptyCloud")
                return
            }
            self.iconImageView.kf.indicatorType = .activity
            self.iconImageView.kf.setImage(with: url, placeholder: UIImage(named: "emptyCloud"))
        })
        .disposed(by: bag)
        
        viewModel.navigateDetailEnable.subscribe(onNext: { value in
            self.navigationItem.rightBarButtonItems = value ? [self.nextButton] : nil
        })
        .disposed(by: bag)
    }

}

extension MainVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let word = searchController.searchBar.text else { return }
        print("Search \(word)")
        viewModel.actionInput.onNext(.search(word: word))
    }
}
