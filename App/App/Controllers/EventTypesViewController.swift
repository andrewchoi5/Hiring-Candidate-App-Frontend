//
//  EventTypesViewController.swift
//  App
//
//  Created by Omid on 2016-08-22.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

protocol EventTypesViewControllerDelegate {
    
    func eventTypesViewController(viewController: EventTypesViewController, didSelectEventType eventType: EventType)
}

class EventTypesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var eventTypes: [EventType] = []
    var hasNext: Bool = true
    
    var delegate: EventTypesViewControllerDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Event Types", comment: "")
        self.tableView.estimatedRowHeight = 50
    }
    
    func getEventTypes() {
        
        self.hasNext = false
        
        EventType.eventTypes { (eventTypes, hasNext, error) in
            
            if let error = error {
                
                NSLog("%@", error.localizedDescription)
                
            } else {
                self.eventTypes = eventTypes
                self.hasNext = hasNext
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.eventTypes.count + Int(self.hasNext)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row < self.eventTypes.count {
            return UITableViewAutomaticDimension
        }
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < self.eventTypes.count {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("EventTypeCell", forIndexPath: indexPath) as! EventTypeCell
            
            cell.eventType = self.eventTypes[indexPath.row]
            
            return cell
            
        } else {
            
            if self.hasNext {
                self.getEventTypes()
            }
            return tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row < self.eventTypes.count {
            self.delegate?.eventTypesViewController(self, didSelectEventType: self.eventTypes[indexPath.row])
        }
    }
}
