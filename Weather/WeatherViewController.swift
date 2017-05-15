//
//  WeatherViewController.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/13/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import UIKit

final class WeatherViewController: UITableViewController {

    //MARK: - Types
    
    fileprivate enum ScopeType: Int {
        case current, weekly
    }
    
    //MARK: - Properties
    
    private lazy var searchController: UISearchController = {
        // initalize search controller without any inital search results
        let search = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation = false
        return search
    }()
    
    fileprivate lazy var request: WeatherSearchRequest = {
        return WeatherSearchRequest(delegate: self)
    }()
    
    fileprivate var currentWeatherDataSource: Weather? {
        didSet {
            self.reloadTableView()
        }
    }
    fileprivate var weeklyWeatherDataSource = [Weather]() {
        didSet {
            self.reloadTableView()
        }
    }
    
    fileprivate var searchBar: UISearchBar {
        return self.searchController.searchBar
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
        self.navigationController?.hidesBarsOnSwipe = true
        
        self.tableView.tableFooterView = UIView()
        
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
    
    fileprivate func reloadTableView() {
        
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let scopeIndex = self.searchBar.selectedScopeButtonIndex
        
        switch ScopeType(rawValue: scopeIndex)! {
        case .current:
            return self.currentWeatherDataSource == nil ? 0 : 1
            
        case .weekly:
            return self.weeklyWeatherDataSource.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.reuseId, for: indexPath) as! WeatherCell
        
        // Configure the cell...
        let scopeIndex = self.searchBar.selectedScopeButtonIndex
        
        var weatherObject: Weather?
        
        switch ScopeType(rawValue: scopeIndex)! {
        case .current:
            weatherObject = self.currentWeatherDataSource
            
        case .weekly:
            weatherObject = self.weeklyWeatherDataSource[indexPath.row]
        }
        
        guard let weather = weatherObject else { return cell }
        cell.configureCell(weather: weather)
        
        return cell
    }
}

// MARK: - UISearchResultsUpdating methods

extension WeatherViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        print(searchString ?? "")
    }
}

// MARK: - UISearchBarDelegate methods

extension WeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        let scopeIndex = searchBar.selectedScopeButtonIndex
        
        switch ScopeType(rawValue: scopeIndex)! {
        case .current:
            //conduct implicit search on change of scope if nessecary
            if self.currentWeatherDataSource == nil && !self.weeklyWeatherDataSource.isEmpty {
                self.searchBarSearchButtonClicked(searchBar)
            }
            
        case .weekly:
            //conduct implicit search on change of scope if nessecary
            if self.currentWeatherDataSource != nil && self.weeklyWeatherDataSource.isEmpty {
                self.searchBarSearchButtonClicked(searchBar)
            }
        }
        
        
        Thread.executeOnMainThread {
            self.reloadTableView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        let scopeIndex = searchBar.selectedScopeButtonIndex
        
        switch ScopeType(rawValue: scopeIndex)! {
        case .current:
            self.request.executeRequestWith(searchTerm: searchText, type: .current)
            
        case .weekly:
            self.request.executeRequestWith(searchTerm: searchText, type: .weekly)
        }
    }
}

// MARK: - WeatherSearchRequestDelegate methods

extension WeatherViewController: WeatherSearchRequestDelegate {
    func weatherSearchRequest(_ request: WeatherSearchRequest, didRecieveCurrent weather: Weather) {
        self.currentWeatherDataSource = weather
    }
    
    func weatherSearchRequest(_ request: WeatherSearchRequest, didRecieveWeekly weather: [Weather]) {
        self.weeklyWeatherDataSource = weather
    }
}

