//
//  SchoolsViewController.swift
//  App
//
//  Created by Omid on 2016-08-17.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

protocol SchoolsViewControllerDelegate {
    
    func schoolsViewController(viewController: SchoolsViewController, didSelectSchool event: School)
}

class SchoolsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var schools: [School] = []
    var filteredSchools: [School] = []
    var hasNext: Bool = true
    
    var delegate: SchoolsViewControllerDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Schools", comment: "")
        self.tableView.estimatedRowHeight = 50
    }
    
    func getSchools(offset offset: Int) {
        
        self.hasNext = false
        
        School.schools(offset, limit: 100) { (schools, hasNext, error) in
            
            if let error = error {
                
                NSLog("%@", error.localizedDescription)
                
            } else {
                self.schools = schools
                self.filteredSchools = schools
                self.hasNext = hasNext
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredSchools.count + Int(self.hasNext)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row < self.filteredSchools.count {
            return UITableViewAutomaticDimension
        }
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < self.filteredSchools.count {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SchoolCell", forIndexPath: indexPath) as! SchoolCell
            
            cell.school = self.filteredSchools[indexPath.row]
            
            return cell
            
        } else {
            
            if self.hasNext {
                self.getSchools(offset: self.filteredSchools.count)
            }
            return tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row < self.schools.count {
            self.delegate?.schoolsViewController(self, didSelectSchool: self.schools[indexPath.row])
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0 {
            self.filteredSchools = self.schools.filter({$0.name?.lowercaseString.rangeOfString(searchText.lowercaseString) != nil || $0.location?.lowercaseString.rangeOfString(searchText.lowercaseString) != nil})
        } else {
            self.filteredSchools = self.schools
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
