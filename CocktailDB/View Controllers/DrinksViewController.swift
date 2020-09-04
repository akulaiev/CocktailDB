//
//  DrinksViewController.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 04.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import UIKit

class DrinksViewController: UIViewController {
    

    @IBOutlet weak var drinksTableView: UITableView!
    var drinkCategories: [String] = []
    var currentCategotyNum: Int = 0
    var drinksForCategories: [CocktailDBResponse?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.text = "Drinks";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        drinksTableView.delegate = self
        drinksTableView.dataSource = self
        drinksTableView.register(UINib.init(nibName: "DrinksTableViewCell", bundle: nil), forCellReuseIdentifier: "DrinksTableViewCell")
        
        CocktailDBAPIClient.getCategotiesList() { response, error in
            guard let response = response else {
                print(error ?? "An error has occured")
                return
            }
            for category in response.drinks {
                self.drinkCategories.append(category.strCategory)
            }
            CocktailDBAPIClient.getDrinkForCategory(category: self.drinkCategories[0].replacingOccurrences(of: " ", with: "_")) { response, error in
                DispatchQueue.main.async {
                    guard let response = response else {
                           print(error ?? "An error has occured")
                           return
                       }
                    self.drinksForCategories.append(response)
                    self.drinksTableView.reloadData()
                }
            }
        }
    }

}

extension DrinksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if drinksForCategories.count > 0 {
            guard let drinks = drinksForCategories[currentCategotyNum] else {return 0}
            return drinks.drinks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinksTableViewCell", for: indexPath) as! DrinksTableViewCell
        cell.drinkName.text = drinksForCategories[currentCategotyNum]?.drinks[indexPath.row].strDrink
        CocktailDBAPIClient.getDrinkImage(drinkUrl: (drinksForCategories[currentCategotyNum]?.drinks[indexPath.row].strDrinkThumb)!) { image, error in
            DispatchQueue.main.async {
                if let image = image {
                    cell.drinkImage.image = image
                }
            }
        }
        cell.drinkImage.image = UIImage(named: "filter")
        return cell
    }
}
