//
//  MenuViewController.swift
//  App
//
//  Created by Omid on 2016-08-10.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        
        if indexPath.row == 0 {
            cell.titleLabel.text = NSLocalizedString("Home", comment: "")
        } else if indexPath.row == 1 {
            cell.titleLabel.text = NSLocalizedString("Resources", comment: "")
        } else if indexPath.row == 2 {
            cell.titleLabel.text = NSLocalizedString("Marketing", comment: "")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            let viewController = UIStoryboard.viewController("HomeViewController")
            self.mainViewController?.navController.viewControllers = [viewController]
        } else if indexPath.row == 1 {
            let viewController = UIStoryboard.viewController("ResourcesViewController")
            self.mainViewController?.navController.viewControllers = [viewController]
        } else if indexPath.row == 2 {

        }
        
        self.mainViewController?.closeMenuAnimated(true)
    }
}
