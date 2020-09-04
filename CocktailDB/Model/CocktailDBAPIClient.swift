//
//  CocktailDBAPIClient.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 04.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class CocktailDBAPIClient {
    
    enum Endpoints {
        static let baseString = "https://www.thecocktaildb.com/api/json/v1/1"

        case categories
        case drinksForCategory

        var stringValue: String {
            switch self {
            case .categories: return Endpoints.baseString + "/list.php?c=list"
            case .drinksForCategory: return Endpoints.baseString + "/filter.php?c="
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getCategotiesList(completion: @escaping (CategoriesResponse?, String?) -> Void) {
        AF.request(Endpoints.categories.stringValue).responseDecodable(of: CategoriesResponse.self) { response in
            if let error = response.error {
                completion(nil, error.localizedDescription)
            }
            else {
                completion(response.value, nil)
            }
        }
    }
    
    class func getDrinkForCategory(category: String, completion: @escaping (CocktailDBResponse?, String?) -> Void) {
        AF.request(Endpoints.drinksForCategory.stringValue + category).responseDecodable(of: CocktailDBResponse.self) {response in
            if let error = response.error {
                completion(nil, error.localizedDescription)
            }
            else {
                completion(response.value, nil)
            }
        }
    }
    
    class func getDrinkImage(drinkUrl: String, completion: @escaping (UIImage?, String?) -> Void) {
        let drinkPreviewUrl = drinkUrl + "/preview"
        AF.request(drinkPreviewUrl).responseImage { response in
            if case .success(let image) = response.result {
                completion(image, nil)
            }
            else {
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
}
