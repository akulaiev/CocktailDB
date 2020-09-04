//
//  CocktailDBAPIClient.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 04.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import Foundation
import Alamofire

class CocktailDBAPIClient {
    
    enum Endpoints {
        static let baseString = "https://www.thecocktaildb.com/api/json/v1/1"

        case categories

        var stringValue: String {
            switch self {
            case .categories: return Endpoints.baseString + "/list.php?c=list"
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
    
    
}
