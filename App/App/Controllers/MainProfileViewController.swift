//
//  MainProfileViewController.swift
//  App
//
//  Created by Omid on 2016-08-11.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class MainProfileViewController: BaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var profile: Profile!
    var pageViewController: UIPageViewController!
    var pageViewControllers: [UIViewController]!

    var contentOffset: CGPoint = CGPoint(x: 0, y: 210) {
        
        didSet {
            
            let y: CGFloat = self.contentOffset.y
            let height: CGFloat = 169
            
            if y < height {
                self.profileViewTop.constant = min(-y, 0)
                self.profileViewHeight.constant = max(210, 210 - y)
                self.navigationItem.title = NSLocalizedString("Candidate Profile", comment: "")
            } else {
                self.profileViewTop.constant = -height
                self.profileViewHeight.constant = 210
                self.navigationItem.title = self.profile.name
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var profileIndicatorView: UIView!
    @IBOutlet weak var reviewsIndicatorView: UIView!
    @IBOutlet weak var historyIndicatorView: UIView!

    @IBOutlet var profileViewTop: NSLayoutConstraint!
    @IBOutlet var profileViewHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let shareButton = UIBarButtonItem(image: UIImage(named: "Share"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainProfileViewController.shareButtonTapped(_:)))
        let optionsButton = UIBarButtonItem(image: UIImage(named: "Options"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainProfileViewController.optionsButtonTapped(_:)))

        self.navigationItem.rightBarButtonItems = [optionsButton, shareButton]
        
        
        self.initialLabel.text = String(self.profile.firstname?.characters.first ?? " ").uppercaseString + String(self.profile.lastname?.characters.first ?? " ").uppercaseString
        self.nameLabel.text = self.profile.name
        self.schoolLabel.text = self.profile.school?.name
        self.locationLabel.text = self.profile.location
        
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.pageViewController.view.frame = self.view.bounds
        self.pageViewController.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.view.insertSubview(self.pageViewController.view, atIndex: 0)
        
        let profileViewController = UIStoryboard.viewController("ProfileViewController") as! ProfileViewController
        profileViewController.mainProfileViewController = self

        let reviewsViewController = UIStoryboard.viewController("ReviewsViewController") as! ReviewsViewController
        reviewsViewController.mainProfileViewController = self

        let historyViewController = UIStoryboard.viewController("HistoryViewController") as! HistoryViewController
        historyViewController.mainProfileViewController = self
        
        self.pageViewControllers = [profileViewController, reviewsViewController, historyViewController]
        
        self.pageViewController.setViewControllers([profileViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        self.updateIndicators()
    }
    
    func updateIndicators() {
        
        if let viewController = self.pageViewController.viewControllers?.first {
            
            self.profileIndicatorView.hidden = !viewController.isKindOfClass(ProfileViewController.classForCoder())
            self.reviewsIndicatorView.hidden = !viewController.isKindOfClass(ReviewsViewController.classForCoder())
            self.historyIndicatorView.hidden = !viewController.isKindOfClass(HistoryViewController.classForCoder())
        }
    }
    
    func shareButtonTapped(sender: UIBarButtonItem) {
        
    }
    
    func optionsButtonTapped(sender: UIBarButtonItem) {
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let index = self.pageViewControllers.indexOf(viewController) {
            if index > 0 {
                return self.pageViewControllers[index - 1]
            } else {
                return self.pageViewControllers[self.pageViewControllers.count - 1]
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let index = self.pageViewControllers.indexOf(viewController) {
            if index < self.pageViewControllers.count - 1 {
                return self.pageViewControllers[index + 1]
            } else {
                return self.pageViewControllers[0]
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        self.updateIndicators()
    }
    
    @IBAction func profileButtonTapped(sender: UIButton) {
        
        self.pageViewController.setViewControllers([self.pageViewControllers[0]], direction: UIPageViewControllerNavigationDirection.Reverse, animated: false, completion: nil)
        self.updateIndicators()
    }
    
    @IBAction func reviewsButtonTapped(sender: UIButton) {
        
        if let _ = self.pageViewController.viewControllers?.first as? ProfileViewController {
            self.pageViewController.setViewControllers([self.pageViewControllers[1]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        } else {
            self.pageViewController.setViewControllers([self.pageViewControllers[1]], direction: UIPageViewControllerNavigationDirection.Reverse, animated: false, completion: nil)
        }
        self.updateIndicators()
    }
    
    @IBAction func historyButtonTapped(sender: UIButton) {
        
        self.pageViewController.setViewControllers([self.pageViewControllers[2]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.updateIndicators()
    }
}