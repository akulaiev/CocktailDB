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
    var model: CocktailsDataModel!
    
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
        
        model = CocktailsDataModel(delegate: self)
        model.fetchCategories()
    }

}

extension DrinksViewController: CocktailsViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?, target: String) {
        print("fetch success")
        if target == "categories" {
            model.fetchDrinksData(tableView: drinksTableView)
        }
        drinksTableView.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
        print(reason)
    }
    
    
}

extension DrinksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let drinks = model.drinksForCategories else {return 0}
        return drinks.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinksTableViewCell", for: indexPath) as! DrinksTableViewCell
        cell.drinkName.text = model.drinksForCategories?.drinks[indexPath.row].strDrink
        return cell
    }
}
