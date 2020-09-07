//
//  FilterViewController.swift
//  CocktailDB
//
//  Created by Anna Kulaieva on 07.09.2020.
//  Copyright © 2020 Anna Kulaieva. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    var allFilters: [String] = []
    var chosenFilters: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenFilters = allFilters
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filtersApplied" {
            let destination = segue.destination as! DrinksViewController
            destination.chosenFilters = chosenFilters
        }
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filterTableView.dequeueReusableCell(withIdentifier: "filterCell")!
        cell.textLabel?.text = allFilters[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.557, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let clickedCell = tableView.cellForRow(at: indexPath) else {return}
        guard let filterName = clickedCell.textLabel?.text else {return}
        if clickedCell.accessoryType == .checkmark {
            clickedCell.accessoryType = .none
        }
        else if clickedCell.accessoryType == .none {
            clickedCell.accessoryType = .checkmark
        }
        if !chosenFilters.contains(filterName) {
            chosenFilters.append(filterName)
        }
        else {
            if let index = chosenFilters.firstIndex(of: filterName) {
                chosenFilters.remove(at: index)
            }
        }
    }
}
