//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Davis Wamola on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController,
                                              didUpdateFilters filters: YelpFilters)
}

//filter list -> category, sort (best match, distance, highest rated), deals (on/off), radius (meters)
struct YelpFilters {
    var categories = [String]()
    var sort: YelpSortMode?
    var deals = false
    var radius: Int?
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    var deals = false
    var sortGroupLastSelected: IndexPath?
    var radiusLastSelected: IndexPath?

    let distance = [10, 30, 50]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = yelpCategories()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)

        var sortMode = YelpSortMode.bestMatched
        var distance: Int?

        if self.sortGroupLastSelected != nil {
            sortMode = YelpSortMode.allValues[self.sortGroupLastSelected!.row]
        }

        if self.radiusLastSelected != nil {
            distance = self.distance[self.radiusLastSelected!.row]
        }
        
        var selectedCategories  = [String]()
        
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        let filters = YelpFilters(categories: selectedCategories, sort: sortMode, deals: self.deals, radius: distance)
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: filters)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)
        switchStates[(indexPath?.row)!] = value
    }

    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code" : "afghani"],
                ["name" : "African", "code" : "african"]]
    }
}
