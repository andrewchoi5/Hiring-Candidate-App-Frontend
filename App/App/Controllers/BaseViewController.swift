//
//  BaseViewController.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var sessionTask: NSURLSessionTask?

    var mainViewController: MainViewController? {
        
        if let mainViewController = self.view.window?.rootViewController as? MainViewController {
            return mainViewController
        }
        return nil
    }
    
    deinit {
        
        self.sessionTask?.cancel()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        if self.presentingViewController != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseViewController.closeButtonTapped(_:)))
        } else if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseViewController.menuButtonTapped(_:)))
        } else if self.navigationController?.viewControllers.count > 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ArrowLeft"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseViewController.backButtonTapped(_:)))
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.view.firstResponder()?.resignFirstResponder()
    }
    
    func menuButtonTapped(sender: UIBarButtonItem) {
        
        self.mainViewController?.openMenuAnimated(true)
    }

    func backButtonTapped(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    func closeButtonTapped(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
