//
//  CocktailDBResponseStructs.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 04.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import Foundation

struct CategoriesResponse: Codable {
    let drinks: [Category]
}

struct Category: Codable {
    let strCategory: String
}

struct CocktailDBResponse: Codable {
    let drinks: [Drink]
}

struct Drink: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}
