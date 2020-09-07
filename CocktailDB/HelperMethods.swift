//
//  HelperMethods.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 06.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import Foundation
import UIKit

class HelperMethods {
    
    class func showFailureAlert(title: String, message: String, controller: UIViewController?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let controller = controller {
            controller.present(alertVC, animated: true)
        }
        else {
            let viewController = UIApplication.shared.windows.first!.rootViewController as! DrinksViewController
            viewController.present(alertVC, animated: true)
        }
    }
}
