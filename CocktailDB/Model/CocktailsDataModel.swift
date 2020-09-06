//
//  CocktailsDataModel.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 05.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import Foundation
import UIKit

protocol CocktailsViewModelDelegate: class {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?, target: String)
    func onFetchFailed(with reason: String)
}

class CocktailsDataModel {
    
    var delegate: CocktailsViewModelDelegate?
    var drinkCategories: [String] = []
    var drinksForCategories: CocktailDBResponse?
    var currentCategoryNum: Int = 0
    var isFetchInProgress = false
    
    init(delegate: CocktailsViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchCategories() {
        guard !isFetchInProgress else {
          return
        }
        isFetchInProgress = true
        CocktailDBAPIClient.getCategotiesList() { response, error in
            guard let response = response else {
                self.delegate?.onFetchFailed(with: error ?? "An error has occured")
                return
            }
            for category in response.drinks {
                self.drinkCategories.append(category.strCategory)
            }
            self.isFetchInProgress = false
            self.delegate?.onFetchCompleted(with: .none, target: "categories")
        }
    }
    
    func fetchDrinksData(tableView: UITableView) {
        if isFetchInProgress || self.drinkCategories.count <= 0 {
            return
        }
        isFetchInProgress = true
        CocktailDBAPIClient.getDrinkForCategory(category: self.drinkCategories[currentCategoryNum].replacingOccurrences(of: " ", with: "_")) { response, error in
                DispatchQueue.main.async {
                guard let response = response else {
                    self.delegate?.onFetchFailed(with: error ?? "An error has occured")
                    return
                }
                self.drinksForCategories = response
                self.delegate?.onFetchCompleted(with: .none, target: "drinksData")
            }
        }
    }
}
