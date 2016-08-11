//
//  EventsViewController.swift
//  App
//
//  Created by Sonalee Shah on 2016-08-09.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

protocol EventsViewControllerDelegate {
    
    func eventsViewController(viewController: EventsViewController, didSelectEvent event: Event)
}

class EventsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    var delegate: EventsViewControllerDelegate?

    var events: [Event] = []
    var hasNext: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        self.navigationItem.title = NSLocalizedString("Events", comment: "")
        
        let searchResultsController = UIStoryboard.viewController("EventsSearchViewController")
        
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController.searchResultsUpdater = self
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.tableView.estimatedRowHeight = 50
    }
    
    func getEvents(offset offset: Int) {
        
        self.hasNext = false
        
        Event.events(offset, limit: 20) { (events, hasNext, error) in
            
            if let error = error {
                
                NSLog("%@", error.localizedDescription)
                
            } else {
                self.events = events
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
        
        self.delegate?.eventsViewController(self, didSelectEvent: self.events[indexPath.row])
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if let searchResultsController = searchController.searchResultsController as? EventsSearchViewController {
            
            searchResultsController.query = searchController.searchBar.text
        }
    }

}
