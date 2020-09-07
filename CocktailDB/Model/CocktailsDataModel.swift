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

    class Objects {
        var sectionName : String!
        var sectionObjects : [Drink]!
        
        init(sectionName: String, sectionObjects: [Drink]) {
            self.sectionName = sectionName
            self.sectionObjects = sectionObjects
        }
    }

    class CocktailsDataModel {
        
        struct CategoryTotal {
            var name: String
            var totalCount: Int
            
            init(name: String, totalCount: Int) {
                self.name = name
                self.totalCount = totalCount
            }
        }
        
        var delegate: CocktailsViewModelDelegate?
        var drinkCategories: [String] = []
        var catrgoriesTotal: [CategoryTotal] = []
        var drinksForCategories = [Objects]()
        var currentCategoryNum: Int = 0
        var isFetchInProgress = false
        
        var filters: [String] = []
        
        init(delegate: CocktailsViewModelDelegate) {
            self.delegate = delegate
        }
        
        func fetchCategories() {
        var categoryCounts = [100, 100, 17, 34, 9, 51, 25, 12, 40, 13, 11]
        CocktailDBAPIClient.getCategotiesList() { response, error in
            guard let response = response else {
                self.delegate?.onFetchFailed(with: error ?? "An error has occured")
                return
            }
            for category in response.drinks {
                self.drinkCategories.append(category.strCategory)
                self.catrgoriesTotal.append(CategoryTotal(name: category.strCategory, totalCount: categoryCounts[0]))
                categoryCounts.remove(at: 0)
            }
            self.fetchDrinksData()
        }
    }
    
    func fetchDrinksData() {
        
        guard !isFetchInProgress else {return}
        isFetchInProgress = true
        if filters.count == 0 {
            filters = drinkCategories
        }
        CocktailDBAPIClient.getDrinkForCategory(category: self.filters[currentCategoryNum].replacingOccurrences(of: " ", with: "_")) { response, error in
                DispatchQueue.main.async {
                self.isFetchInProgress = false
                guard let response = response else {
                    self.delegate?.onFetchFailed(with: error ?? "An error has occured")
                    return
                }
                self.drinksForCategories.append(Objects(sectionName: self.filters[self.currentCategoryNum], sectionObjects: response.drinks))
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
        let startIndex = drinksForCategories[currentCategoryNum].sectionObjects.count - newDrinks.count
        let endIndex = startIndex + newDrinks.count
        var indexPaths: [IndexPath] = []
        for i in startIndex..<endIndex {
            indexPaths.append(IndexPath(row: i, section: currentCategoryNum))
        }
        return indexPaths
    }
}
