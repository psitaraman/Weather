//
//  WeatherViewController.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/13/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import UIKit

final class WeatherViewController: UITableViewController {

    //MARK: - Properties
    
    private lazy var searchController: UISearchController = {
        // initalize search controller without any inital search results
        let search = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation = true
        return search
    }()
    
    fileprivate lazy var request: WeatherSearchRequest = {
        return WeatherSearchRequest()
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
        self.navigationController?.hidesBarsOnSwipe = true
        
        self.configureSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    private func configureSearchController() {
        self.searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
       
        // configure search bar
        let buttonTitles = [LocalizedStrings.WeatherSearchBar.currentForecastScopeButtonTitle, LocalizedStrings.WeatherSearchBar.weeklyForecastScopeButtonTitle]
        
        self.searchController.searchBar.placeholder = LocalizedStrings.WeatherSearchBar.placeholderText
        self.searchController.searchBar.scopeButtonTitles = buttonTitles
        self.searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UISearchResultsUpdating methods

extension WeatherViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        //Thread.executeOnMainThread { self.tableView.reloadData() }
    }
}

// MARK: - UISearchBarDelegate methods

extension WeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        let scopeIndex = searchBar.selectedScopeButtonIndex
        
        switch scopeIndex {
        case 0:
            self.request.executeRequestWith(searchTerm: searchText, type: .current)
            
        case 1:
            self.request.executeRequestWith(searchTerm: searchText, type: .weekly)
            
        default:
            break
        }
    }
}



