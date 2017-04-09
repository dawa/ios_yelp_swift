//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate {
    
    var businesses: [Business]!
    var searchTerm = "Restaurants"
    var yelpFilters: YelpFilters?
    var offset: Int = 0
    let limit: Int = 20
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Add a search bar
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "thai, sandwiches"
        self.navigationItem.titleView = searchBar
        
        // Run Yelp search with default term = "Restaurants"
        doSearch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
     }

    func doSearch() {
        if self.yelpFilters != nil {
            Business.searchWithTerm(term: self.searchTerm, parameters: self.getSearchParameters(),
                                    completion: { (businesses: [Business]?, error: Error?) -> Void in
                                        self.businesses = businesses
                                        self.tableView.reloadData()
            })
        }else {
            Business.searchWithTerm(term: self.searchTerm,
                                    completion: { (businesses: [Business]!, error: Error!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            })
        }
        self.yelpFilters = nil
    }

    func getSearchParameters() -> [String : AnyObject] {
        var parameters = [String : AnyObject]()

        for (key, value) in YelpFilters.instance.parameters {
            parameters[key] = value as AnyObject
        }
        return parameters
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchText
        self.doSearch()
    }

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: YelpFilters) {
        self.searchTerm = "Restaurants"
        self.yelpFilters = filters
        doSearch()
    }
}
