//
//  ReviewsViewController.swift
//  App
//
//  Created by Omid on 2016-08-11.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class ReviewsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
 
    var mainProfileViewController: MainProfileViewController?
    
    var reviews: [Review] = []
    var hasNext: Bool = true

    @IBOutlet weak var tableView: UITableView!

    deinit {
        
        self.tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 50
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

    func getReviews(offset offset: Int) {
        
        self.hasNext = false
        
        self.sessionTask?.cancel()
        self.sessionTask = self.mainProfileViewController?.profile.reviews(offset, limit: 20, completion: { (reviews, hasNext, error) in
            
            if let error = error {
                
                NSLog("%@", error.localizedDescription)
                
            } else {
                self.reviews = reviews
                self.reviews = [Review(data: NSDictionary()), Review(data: NSDictionary()), Review(data: NSDictionary())]
                self.hasNext = hasNext
                self.tableView.reloadData()
            }
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 4
        } else if section == 1 {
            return 1
        } else {
            return self.reviews.count + Int(self.hasNext)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 40
        } else if indexPath.section == 1 {
            return 40
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CompetencyCell", forIndexPath: indexPath) as! CompetencyCell
            
            if indexPath.row == 0 {
                cell.titleLabel.text = NSLocalizedString("Leadership Skills", comment: "")
                cell.value = 1
            } else if indexPath.row == 1 {
                cell.titleLabel.text = NSLocalizedString("Campus Experience", comment: "")
                cell.value = 3
            } else if indexPath.row == 2 {
                cell.titleLabel.text = NSLocalizedString("Campus Experience", comment: "")
                cell.value = 2
            } else if indexPath.row == 3 {
                cell.titleLabel.text = NSLocalizedString("Campus Experience", comment: "")
                cell.value = 5
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            return tableView.dequeueReusableCellWithIdentifier("AddReviewCell", forIndexPath: indexPath)
            
        } else if indexPath.row < self.reviews.count {
                
            let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell", forIndexPath: indexPath) as! ReviewCell
            
            cell.review = self.reviews[indexPath.row]
            
            return cell
            
        } else {
            
            if self.hasNext {
                self.getReviews(offset: self.reviews.count)
            }
            return tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 {
            
            let createReviewViewController = UIStoryboard.viewController("CreateReviewViewController") as! CreateReviewViewController
            createReviewViewController.profile = self.mainProfileViewController?.profile
            
            let navigationController = UINavigationController(rootViewController: createReviewViewController)
            self.mainProfileViewController?.presentViewController(navigationController, animated: true, completion: nil)
            
        } else if indexPath.section == 2 {
            if indexPath.row < self.reviews.count {
                
                let reviewViewController = UIStoryboard.viewController("ReviewViewController") as! ReviewViewController
                reviewViewController.review = self.reviews[indexPath.row]
                
                self.navigationController?.pushViewController(reviewViewController, animated: true)
            }
        }
    }
}