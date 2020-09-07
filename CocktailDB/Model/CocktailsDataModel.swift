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
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class CocktailsDataModel {
    
    var delegate: CocktailsViewModelDelegate?
    var drinkCategories: [String] = []
    var drinksForCategories: [Drink] = []
    var currentCategoryNum: Int = 0
    var isFetchInProgress = false
    var total: Int = 0
    
    init(delegate: CocktailsViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchCategories() {
        CocktailDBAPIClient.getCategotiesList() { response, error in
            guard let response = response else {
                self.delegate?.onFetchFailed(with: error ?? "An error has occured")
                return
            }
            for category in response.drinks {
                self.drinkCategories.append(category.strCategory)
            }
            self.fetchDrinksData()
        }
    }
    
    func fetchDrinksData() {
        guard !isFetchInProgress else {return}
        isFetchInProgress = true
        CocktailDBAPIClient.getDrinkForCategory(category: self.drinkCategories[currentCategoryNum].replacingOccurrences(of: " ", with: "_")) { response, error in
                DispatchQueue.main.async {
                self.isFetchInProgress = false
                guard let response = response else {
                    self.delegate?.onFetchFailed(with: error ?? "An error has occured")
                    return
                }
                self.total = 604 + self.drinkCategories.count
                self.drinksForCategories.append(Drink(strDrink: self.drinkCategories[self.currentCategoryNum], idDrink: "category"))
                self.drinksForCategories.append(contentsOf: response.drinks)
                if self.currentCategoryNum > 0 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: response.drinks)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                }
                else {
                    self.delegate?.onFetchCompleted(with: .none)
                }
                if self.currentCategoryNum + 1 < self.drinkCategories.count {
                    self.currentCategoryNum += 1
                }
            }
        }
    }
    
    func calculateIndexPathsToReload(from newDrinks: [Drink]) -> [IndexPath] {
        let startIndex = drinksForCategories.count - newDrinks.count
        let endIndex = startIndex + newDrinks.count
        var indexPaths: [IndexPath] = []
        for i in startIndex..<endIndex {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        return indexPaths
    }
}
