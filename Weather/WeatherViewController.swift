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
    
    fileprivate let imageDataSource = ImageDataSource()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
        self.navigationController?.hidesBarsOnSwipe = true
        self.tableView.prefetchDataSource = self
        
        self.tableView.tableFooterView = UIView()
        
        self.configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.preloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        self.imageDataSource.clearCache()
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
    
    private func preloadData() {
        // preload search and search results with last search
        guard let (searchTerm, scopeIndex) = self.retrieveSearchHistory() else { return }
        self.searchBar.text = searchTerm
        self.searchBar.selectedScopeButtonIndex = scopeIndex
        self.searchBarSearchButtonClicked(self.searchBar)
    }
    
    fileprivate func weatherForScopeIndex(_ index: Int, for indexPath: IndexPath) -> Weather? {
        
        switch ScopeType(rawValue: index)! {
        case .current:
            return self.currentWeatherDataSource
            
        case .weekly:
            return self.weeklyWeatherDataSource[indexPath.row]
        }
    }
    
    fileprivate func reloadTableView() {
        
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    fileprivate func saveSearch(searchTerm: String, scopeIndex: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(searchTerm, forKey: "searchTerm")
        userDefaults.set(scopeIndex, forKey: "scopeIndex")
        userDefaults.synchronize()
    }
    
    fileprivate func saveScopeIndex(_ index: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(index, forKey: "scopeIndex")
        userDefaults.synchronize()
    }
    
    fileprivate func retrieveSearchHistory() -> (String, Int)? {
        let userDefaults = UserDefaults.standard
        let searchTerm = userDefaults.value(forKey: "searchTerm") as? String
        let scopeIndex = userDefaults.integer(forKey: "scopeIndex")
        
        return searchTerm != nil ? (searchTerm!, scopeIndex) : nil
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
        
        guard let weather = self.weatherForScopeIndex(scopeIndex, for: indexPath) else { return cell }
        cell.configureCell(weatherViewModel: WeatherCellViewModel(weather: weather))
        cell.iconIdentifier = IndexPath(row: indexPath.row, section: scopeIndex)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! WeatherCell
        let scopeIndex = self.searchBar.selectedScopeButtonIndex

        guard let weather = self.weatherForScopeIndex(scopeIndex, for: indexPath) else { return }
        let imageIndexPath = IndexPath(row: indexPath.row, section: scopeIndex)
        self.imageDataSource.imageWith(url: weather.iconUrl, for: imageIndexPath) {(image, indexPath) in
            // check to see if the image requested cell still has the same id or if it has been reused, if reused, don't set image
            guard cell.iconIdentifier == IndexPath(row: indexPath.row, section: scopeIndex) else { return }
            Thread.executeOnMainThread {
                cell.iconImageView.image = image
            }
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching methods

extension WeatherViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        let scopeIndex = self.searchBar.selectedScopeButtonIndex

        for indexPath in indexPaths {
            if let weather = self.weatherForScopeIndex(scopeIndex, for: indexPath) {
                self.imageDataSource.prefetchImageWith(url: weather.iconUrl, for: IndexPath(row: indexPath.row, section: scopeIndex))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
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
        
        Thread.executeOnBackgroundThread {
            self.saveScopeIndex(scopeIndex)
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
        
        Thread.executeOnBackgroundThread { 
            self.saveSearch(searchTerm: searchText, scopeIndex: scopeIndex)
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
    
    func weatherSearchRequest(_ request: WeatherSearchRequest, didRecieveError error: NSError) {
        guard let message = error.userInfo[WeatherSearchRequest.Constants.errorKey] as? String else { return }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

