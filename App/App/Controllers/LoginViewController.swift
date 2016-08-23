//
//  LoginViewController.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation

class LoginViewController: BaseViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!

    @IBOutlet weak var bgImageView: UIImageView!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet var topViewHeight: NSLayoutConstraint!
    @IBOutlet var bottomViewHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loginButton.enabled = false
        self.loginButton.backgroundColor = UIColor.primaryDisabledButtonColor()
        
        self.requestButton.backgroundColor = UIColor.secondryButtonColor()
        
        self.emailTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.6).CGColor
        self.emailTextField.clipsToBounds = true
        
        self.passwordTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.6).CGColor
        self.passwordTextField.clipsToBounds = true
        
        let url = NSBundle.mainBundle().URLForResource("Login", withExtension: "mov")!
        self.player = AVPlayer(URL: url)
        self.player.play()
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.bgImageView.layer.addSublayer(self.playerLayer)
        
        NSNotificationCenter.defaultCenter().addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: nil, queue: nil) { (notification) in
            
            self.player.seekToTime(kCMTimeZero)
            self.player.play()
        }

        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillResignActiveNotification, object: nil, queue: nil) { (notification) in
            
            self.player.pause()
        }

        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: nil) { (notification) in
            
            self.player.play()
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        self.playerLayer.frame = self.bgImageView.bounds
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.loginButtonTapped(self.loginButton)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        return !self.activityIndicator.isAnimating()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration((userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.integerValue ?? 0) ?? UIViewAnimationCurve.Linear)
            
            self.topView.alpha = 0
            self.bottomView.alpha = 0
            
            self.topViewHeight.active = false
            self.bottomViewHeight.active = false
            
            self.view.layoutIfNeeded()
            
            UIView.commitAnimations()
        }
    }
    
    func keyboardWillHide(notification: NSNotification)  {
        
        if let userInfo = notification.userInfo {
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration((userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.integerValue ?? 0) ?? UIViewAnimationCurve.Linear)
            
            self.topView.alpha = 1
            self.bottomView.alpha = 1
            
            self.topViewHeight.active = true
            self.bottomViewHeight.active = true
            
            self.view.layoutIfNeeded()
            
            UIView.commitAnimations()
        }
    }
    
    @IBAction func requestButtonTapped(sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients(["nomid@ca.ibm.com"])
            mailComposeViewController.setSubject("Request Access")
            
            mailComposeViewController.navigationBar.tintColor = UIColor.whiteColor()
            mailComposeViewController.navigationBar.barTintColor = UIColor.whiteColor()
            mailComposeViewController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]

            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            
        } else {
            
            let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: "Your device not configured to send email.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        
        self.view.firstResponder()?.resignFirstResponder()
        
        self.loginButton.enabled = false
        self.loginButton.setTitle("", forState: UIControlState.Normal)
        self.activityIndicator.startAnimating()
        
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        APIManager.sharedManager.email = email
        APIManager.sharedManager.password = password
        
        self.sessionTask?.cancel()
        self.sessionTask = User.user(email) { (user, error) in
            
            self.passwordTextField.text = nil
            self.textFieldEditingChanged(self.passwordTextField)

            self.loginButton.enabled = true
            self.loginButton.setTitle(NSLocalizedString("Login", comment: ""), forState: UIControlState.Normal)
            self.activityIndicator.stopAnimating()
            
            if let error = error {
                
                let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else if let user = user {
                
                if user.accessLevel == User.AccessLevel.Editor.rawValue {
                    let viewController = UIStoryboard.viewController("CreateProfileViewController")
                    self.view.window?.rootViewController = UINavigationController(rootViewController: viewController)
                } else {
                    self.view.window?.rootViewController = UIStoryboard.viewController("MainViewController")
                }                
            }
        }
    }

    @IBAction func textFieldEditingChanged(sender: UITextField) {
        
        if self.emailTextField.hasText() && self.passwordTextField.hasText() {
            self.loginButton.enabled = true
            self.loginButton.backgroundColor = UIColor.primaryButtonColor()
        } else {
            self.loginButton.enabled = false
            self.loginButton.backgroundColor = UIColor.primaryDisabledButtonColor()
        }
    }
}
