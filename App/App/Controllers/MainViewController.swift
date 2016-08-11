//
//  MainViewController.swift
//  App
//
//  Created by Omid on 2016-08-10.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var menuContainerView: UIView!
    @IBOutlet var mainContainerView: UIView!
    
    @IBOutlet var navController: UINavigationController!
    @IBOutlet var mainContainerViewLeading: NSLayoutConstraint!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navController = segue.destinationViewController as? UINavigationController where segue.identifier == "NavigationControllerSegue" {
            
            self.navController = navController
        }
    }
    
    func openMenuAnimated(animated: Bool) {
        
        if animated {
            UIView.animateWithDuration(0.2, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseOut], animations: {
                
                self.openMenuAnimated(false)
                
                }, completion: nil)
        } else {
            self.mainContainerView.userInteractionEnabled = false
            self.mainContainerViewLeading.constant = self.menuContainerView.bounds.size.width
            self.view.layoutIfNeeded()
        }
    }
    
    func closeMenuAnimated(animated: Bool) {
        
        if animated {
            UIView.animateWithDuration(0.2, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseOut], animations: {
                
                self.closeMenuAnimated(false)
                
                }, completion: nil)
        } else {
            self.mainContainerView.userInteractionEnabled = true
            self.mainContainerViewLeading.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let location = gestureRecognizer.locationInView(self.view)
        
        return  self.mainContainerViewLeading.constant > 0 && CGRectContainsPoint(self.mainContainerView.frame, location)
    }
    
    @IBAction func tapGestureHandler(sender: UITapGestureRecognizer) {
        
        self.closeMenuAnimated(true)
    }
}
