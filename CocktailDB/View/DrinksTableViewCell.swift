//
//  DrinksTableViewCell.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 04.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import UIKit

class DrinksTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(drinkInfo: Drink?, targetVC: UIViewController) {
        if let drinkInfo = drinkInfo {
            drinkName.text = drinkInfo.strDrink
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            CocktailDBAPIClient.getDrinkImage(drinkUrl: drinkInfo.strDrinkThumb) { image, error in
                DispatchQueue.main.async {
                    guard let image = image else {
                        HelperMethods.showFailureAlert(title: "Warning", message: error ?? "An error has ocured", controller: targetVC)
                            return
                    }
                    self.drinkImage.image = image
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }
        else {
            drinkName.text = ""
            drinkImage.image = nil
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
}
