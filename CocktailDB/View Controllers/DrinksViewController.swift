//
//  DrinksViewController.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 04.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import UIKit

class DrinksViewController: UIViewController {
    
    @IBOutlet weak var drinksCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drinksCollectionView.delegate = self
        drinksCollectionView.dataSource = self
        drinksCollectionView.register(UINib.init(nibName: "DrinksCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DrinksCollectionViewCell")
    }

}

extension DrinksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinksCollectionViewCell", for: indexPath) as! DrinksCollectionViewCell
        cell.cocktailName.text = "YoYoYo!!!"
        cell.cocktailImg.image = UIImage(named: "filter")
        return cell
    }
}
