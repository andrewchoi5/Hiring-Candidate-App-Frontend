//
//  ProfileViewController.swift
//  App
//
//  Created by Omid on 2016-08-11.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mainProfileViewController: MainProfileViewController?
    
    var personalAttributes: [String] = ["A", "B"]
    var skills: [String] = ["C", "C++", "C#", "Java", "Swift", "Javascript"]
    var serviceLines: [String] = ["1", "2", "3", "4", "5", "6"]
    
    var personalAttributesFlag: Bool = true
    var skillsFlag: Bool = true
    var serviceLinesFlag: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    
    deinit {
        
        self.tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.tableView.contentOffset = CGPointZero
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let object = object as? UITableView where object == self.tableView,
            let keyPath = keyPath where keyPath == "contentOffset" {
            
            self.mainProfileViewController?.contentOffset = self.tableView.contentOffset
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if self.personalAttributesFlag {
                return min(self.personalAttributes.count, 5) + 1
            }
        } else if section == 1 {
            if self.skillsFlag {
                return min(self.skills.count, 5) + 1
            }
        } else if section == 2 {
            if serviceLinesFlag {
                return min(self.serviceLines.count, 5) + 1
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileHeaderCell", forIndexPath: indexPath) as! ProfileHeaderCell
            
            if indexPath.section == 0 {
                cell.titleLabel.text = NSLocalizedString("Personal Attributes", comment: "")
            } else if indexPath.section == 1 {
                cell.titleLabel.text = NSLocalizedString("Skills", comment: "")
            } else if indexPath.section == 2 {
                cell.titleLabel.text = NSLocalizedString("Service Lines", comment: "")
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileItemCell", forIndexPath: indexPath) as! ProfileItemCell
            
            if indexPath.section == 0 {
                cell.nameLabel.text = self.personalAttributes[indexPath.row - 1]
            } else if indexPath.section == 1 {
                cell.nameLabel.text = self.skills[indexPath.row - 1]
            } else if indexPath.section == 2 {
                cell.nameLabel.text = self.serviceLines[indexPath.row - 1]
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.row == 0 {
            if indexPath.section == 0 {
                self.personalAttributesFlag = !self.personalAttributesFlag
            } else if indexPath.section == 1 {
                self.skillsFlag = !self.skillsFlag
            } else if indexPath.section == 2 {
                self.serviceLinesFlag = !self.serviceLinesFlag
            }
        }
    }
    
    @IBAction func plusButtonTapped(sender: UIButton) {
        
    }
}