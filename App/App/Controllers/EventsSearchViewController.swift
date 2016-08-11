//
//  EventsSearchViewController.swift
//  App
//
//  Created by Sonalee Shah on 2016-08-09.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class EventsSearchViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var events: [Event] = []
    var hasNext: Bool = false
    
    var query: String? {
        
        didSet {
            self.events = []
            self.hasNext = self.query?.characters.count > 0
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 50
    }
    
    func getEvents(offset offset: Int) {
        
        self.hasNext = false
        
        Event.events(self.query ?? "", offset: offset, limit: 20) { (profiles, hasNext, error) in
            
            if let error = error {
                
                NSLog("%@", error.localizedDescription)
                
            } else {
                self.events = profiles
                self.hasNext = hasNext
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.events.count + Int(self.hasNext)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row < self.events.count {
            return UITableViewAutomaticDimension
        }
        return 50
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < self.events.count {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
            
            cell.event = self.events[indexPath.row]
            
            return cell
            
        } else {
            
            if self.hasNext {
                self.getEvents(offset: self.events.count)
            }
            return tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath)
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let createProfileViewController = self.presentingViewController as? CreateProfileViewController {
            
            createProfileViewController.profile.event = self.events[indexPath.row]
            createProfileViewController.tableView.reloadData()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
