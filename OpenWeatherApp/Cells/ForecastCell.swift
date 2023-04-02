//
//  ForecastCell.swift
//  OpenWeatherApp
//
//  Created by Tạ Minh Quân on 27/03/2023.
//

import UIKit
import BusinessLogic
import Kingfisher

class ForecastCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempatureLabel: UILabel!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(_ cellModel: ForecastCellModel) {
        guard let url = URL(string: cellModel.displayIcon) else {
            self.iconImageView.image = UIImage(named: "emptyCloud")
            return
        }
        self.iconImageView.kf.indicatorType = .activity
        self.iconImageView.kf.setImage(with: url, placeholder: UIImage(named: "emptyCloud"))
        tempatureLabel.text = cellModel.displayTempature
        humLabel.text = cellModel.displayHumidity
        dateTimeLabel.text = cellModel.displayDateTime
    }
    
}
