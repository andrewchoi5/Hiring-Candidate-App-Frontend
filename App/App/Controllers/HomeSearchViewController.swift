//
//  HomeSearchViewController.swift
//  App
//
//  Created by Sonalee Shah on 2016-08-08.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class HomeSearchViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var profiles: [Profile] = []
    var hasNext: Bool = false
    
    var query: String? {
        
        didSet {
            self.profiles = []
            self.hasNext = self.query?.characters.count > 0
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 50
    }
    
    func getProfiles(offset offset: Int) {
        
        self.hasNext = false
        
        Profile.profiles(self.query ?? "", offset: offset, limit: 20) { (profiles, hasNext, error) in
            
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
}
