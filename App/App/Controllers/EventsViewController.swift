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

class EventsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var events: [Event] = []
    var filteredEvents: [Event] = []
    var hasNext: Bool = true
    
    var delegate: EventsViewControllerDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Events", comment: "")
        self.tableView.estimatedRowHeight = 50
    }
    
    func getEvents(offset offset: Int) {
        
        self.hasNext = false
        
        Event.events(offset, limit: 100) { (events, hasNext, error) in
            
            if let error = error {
                
                NSLog("%@", error.localizedDescription)
                
            } else {
                self.events = events
                self.filteredEvents = events
                self.hasNext = hasNext
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.filteredEvents.count + Int(self.hasNext)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row < self.filteredEvents.count {
            return UITableViewAutomaticDimension
        }
        return 50
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < self.filteredEvents.count {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell

            cell.event = self.filteredEvents[indexPath.row]
            
            return cell
            
        } else {
            
            if self.hasNext {
                self.getEvents(offset: self.filteredEvents.count)
            }
            return tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row < self.filteredEvents.count {
            self.delegate?.eventsViewController(self, didSelectEvent: self.filteredEvents[indexPath.row])
        }
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0 {
            self.filteredEvents = self.events.filter({$0.name?.lowercaseString.rangeOfString(searchText.lowercaseString) != nil || $0.eventType?.name?.lowercaseString.rangeOfString(searchText.lowercaseString) != nil || $0.location?.lowercaseString.rangeOfString(searchText.lowercaseString) != nil})
        } else {
            self.filteredEvents = self.events
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
