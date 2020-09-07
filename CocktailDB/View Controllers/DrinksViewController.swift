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
    var chosenFilters: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.text = "Drinks";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)], for: .normal)
        
        drinksTableView.delegate = self
        drinksTableView.dataSource = self
        drinksTableView.register(UINib.init(nibName: "DrinksTableViewCell", bundle: nil), forCellReuseIdentifier: "DrinksTableViewCell")
        drinksTableView.prefetchDataSource = self
        
        model = CocktailsDataModel(delegate: self)
        model.fetchCategories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(chosenFilters)
        model.filters = chosenFilters
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilter" {
            let destination = segue.destination as! FilterViewController
            destination.allFilters = model.drinkCategories
        }
    }
}

extension DrinksViewController: CocktailsViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            drinksTableView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(indexPaths: newIndexPathsToReload)
        drinksTableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        HelperMethods.showFailureAlert(title: "Warning", message: reason, controller: self)
    }
    
}

extension DrinksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.drinkCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.catrgoriesTotal[section]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if model.drinkCategories.count > 0 {
            return model.drinkCategories[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinksTableViewCell", for: indexPath) as! DrinksTableViewCell
        if isLoadingCell(for: indexPath) {
            cell.configure(drinkInfo: nil, targetVC: self)
        }
        else {
            cell.configure(drinkInfo: model.drinksForCategories[indexPath.section].sectionObjects[indexPath.row], targetVC: self)
        }
        return cell
    }
}

extension DrinksViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            model.fetchDrinksData()
        }
    }
}

private extension DrinksViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if indexPath.section >= model.drinksForCategories.count {
            return true
        }
        return indexPath.row >= model.drinksForCategories[indexPath.section].sectionObjects.count
    }

    func visibleIndexPathsToReload(indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = drinksTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
