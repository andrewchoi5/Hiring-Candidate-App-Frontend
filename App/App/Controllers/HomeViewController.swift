//
//  HomeViewController.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    
    var profiles: [Profile] = []
    var hasNext: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        self.navigationItem.title = NSLocalizedString("Home", comment: "")
        
        let searchResultsController = UIStoryboard.viewController("HomeSearchViewController")
        
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController.searchResultsUpdater = self
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.tableView.estimatedRowHeight = 50
    }

    func getProfiles(offset offset: Int) {

        self.hasNext = false
        
        Profile.profiles(offset, limit: 20) { (profiles, hasNext, error) in
            
            if let error = error {
                
                NSLog("%@", error.localizedDescription)

            } else {
                self.profiles = profiles
                self.hasNext = hasNext
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.profiles.count + Int(self.hasNext)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row < self.profiles.count {
            return UITableViewAutomaticDimension
        }
        return 50
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < self.profiles.count {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
            
            cell.profile = self.profiles[indexPath.row]
            
            return cell
            
        } else {
            
            if self.hasNext {
                self.getProfiles(offset: self.profiles.count)
            }
            return tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if let searchResultsController = searchController.searchResultsController as? HomeSearchViewController {
            searchResultsController.query = searchController.searchBar.text
        }
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        
        let viewController = UIStoryboard.viewController("CreateProfileViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
