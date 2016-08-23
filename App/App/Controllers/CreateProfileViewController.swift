//
//  CreateProfileViewController.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class CreateProfileViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SchoolsViewControllerDelegate, EventsViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet var tableViewBottom: NSLayoutConstraint!

    let profile: Profile = Profile(data: NSDictionary())

    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    var keyboardToolbar: UIToolbar!
    
    let locations = ["Calgary", "Edmonton", "Montreal", "Ottawa", "Toronto", "Vancouver"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Candidate Information", comment: "")
        
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        
        self.pickerView = UIPickerView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(CreateProfileViewController.cancelButtonTapped(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(CreateProfileViewController.doneButtonTapped(_:)))
        
        self.createButton.enabled = true
        self.createButton.backgroundColor = UIColor.primaryButtonColor()

        self.keyboardToolbar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
        self.keyboardToolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
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

    func cancelButtonTapped(sender: UIBarButtonItem) {
        
        self.tableView.reloadData()
        self.view.firstResponder()?.resignFirstResponder()
    }
    
    func doneButtonTapped(sender: UIBarButtonItem) {
        
        if self.pickerView.tag == 3 {
            self.profile.location = self.locations[self.pickerView.selectedRowInComponent(0)]
        }
        
        if self.datePicker.tag == 5 {
            self.profile.graduationDate = self.datePicker.date
        }
        
        self.tableView.reloadData()
        self.view.firstResponder()?.resignFirstResponder()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 4
        } else if section == 1 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath) as! TextFieldCell

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.textField.tag = 0
                cell.textField.inputView = nil
                cell.textField.inputAccessoryView = nil
                cell.textField.userInteractionEnabled = true
                cell.textField.autocapitalizationType = UITextAutocapitalizationType.Words
                cell.textField.autocorrectionType = UITextAutocorrectionType.No
                cell.textField.spellCheckingType = UITextSpellCheckingType.No
                cell.textField.returnKeyType = UIReturnKeyType.Done
                cell.textField.keyboardType = UIKeyboardType.ASCIICapable
                cell.textField.placeholder = NSLocalizedString("First Name", comment: "")
                cell.textField.text = self.profile.firstname

            } else if indexPath.row == 1 {
                
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.textField.tag = 1
                cell.textField.inputView = nil
                cell.textField.inputAccessoryView = nil
                cell.textField.userInteractionEnabled = true
                cell.textField.autocapitalizationType = UITextAutocapitalizationType.Words
                cell.textField.autocorrectionType = UITextAutocorrectionType.No
                cell.textField.spellCheckingType = UITextSpellCheckingType.No
                cell.textField.returnKeyType = UIReturnKeyType.Done
                cell.textField.keyboardType = UIKeyboardType.ASCIICapable
                cell.textField.placeholder = NSLocalizedString("Last Name", comment: "")
                cell.textField.text = self.profile.lastname
                
            } else if indexPath.row == 2 {
                
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.textField.tag = 2
                cell.textField.inputView = nil
                cell.textField.inputAccessoryView = nil
                cell.textField.userInteractionEnabled = true
                cell.textField.autocapitalizationType = UITextAutocapitalizationType.None
                cell.textField.autocorrectionType = UITextAutocorrectionType.No
                cell.textField.spellCheckingType = UITextSpellCheckingType.No
                cell.textField.returnKeyType = UIReturnKeyType.Done
                cell.textField.keyboardType = UIKeyboardType.EmailAddress
                cell.textField.placeholder = NSLocalizedString("Email", comment: "")
                cell.textField.text = self.profile.email
                
            } else if indexPath.row == 3 {
                
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.textField.tag = 3
                cell.textField.inputView = self.pickerView
                cell.textField.inputAccessoryView = self.keyboardToolbar
                cell.textField.userInteractionEnabled = true
                cell.textField.placeholder = NSLocalizedString("Location", comment: "")
                cell.textField.text = self.profile.location
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                
                cell.textField.tag = 4
                cell.textField.inputView = nil
                cell.textField.inputAccessoryView = nil
                cell.textField.userInteractionEnabled = false
                cell.textField.placeholder = NSLocalizedString("School", comment: "")
                cell.textField.text = self.profile.school?.name
                
            } else if indexPath.row == 1 {

                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.textField.tag = 5
                cell.textField.inputView = self.datePicker
                cell.textField.inputAccessoryView = self.keyboardToolbar
                cell.textField.userInteractionEnabled = true
                cell.textField.placeholder = NSLocalizedString("Graduation Date", comment: "")
                
                if let graduationDate = self.profile.graduationDate {
                    cell.textField.text = dateFormatter.stringFromDate(graduationDate)
                } else {
                    cell.textField.text = nil
                }

            } else if indexPath.row == 2 {
                
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.textField.tag = 6
                cell.textField.inputView = nil
                cell.textField.inputAccessoryView = nil
                cell.textField.userInteractionEnabled = true
                cell.textField.autocapitalizationType = UITextAutocapitalizationType.Words
                cell.textField.autocorrectionType = UITextAutocorrectionType.No
                cell.textField.spellCheckingType = UITextSpellCheckingType.No
                cell.textField.returnKeyType = UIReturnKeyType.Done
                cell.textField.keyboardType = UIKeyboardType.ASCIICapable
                cell.textField.placeholder = NSLocalizedString("Degree", comment: "")
                cell.textField.text = self.profile.degree
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                
                cell.textField.tag = 7
                cell.textField.inputView = nil
                cell.textField.inputAccessoryView = nil
                cell.textField.userInteractionEnabled = false
                cell.textField.placeholder = NSLocalizedString("Event", comment: "")
                cell.textField.text = self.profile.event?.name
                cell.textField.tag = indexPath.row
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                
                let schoolsViewController = UIStoryboard.viewController("SchoolsViewController") as! SchoolsViewController
                schoolsViewController.delegate = self
                
                let navigationController = UINavigationController(rootViewController: schoolsViewController)
                self.presentViewController(navigationController, animated: true, completion: nil)
                
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                
                let eventsViewController = UIStoryboard.viewController("EventsViewController") as! EventsViewController
                eventsViewController.delegate = self
                
                let navigationController = UINavigationController(rootViewController: eventsViewController)
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        self.datePicker.tag = textField.tag
        self.pickerView.tag = textField.tag
        self.pickerView.reloadAllComponents()

        if textField.tag == 3 {
            self.pickerView.selectRow(self.locations.indexOf(textField.text ?? "") ?? 0, inComponent: 0, animated: false)
        } else if textField.tag == 5 {
            self.datePicker.date = self.profile.graduationDate ?? NSDate()
        }

        return !self.activityIndicator.isAnimating()
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            self.profile.firstname = textField.text
        } else if textField.tag == 1 {
            self.profile.lastname = textField.text
        } else if textField.tag == 2 {
            self.profile.email = textField.text
        } else if textField.tag == 6 {
            self.profile.degree = textField.text
        }
        self.tableView.reloadData()
        
        return true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 3 {
            return self.locations.count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 3 {
            return self.locations[row]
        } else {
            return ""
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {

            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration((userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.integerValue ?? 0) ?? UIViewAnimationCurve.Linear)
            
            self.tableViewBottom.constant = keyboardFrame.size.height
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
            
            self.tableViewBottom.constant = 0
            self.view.layoutIfNeeded()
            
            UIView.commitAnimations()
        }
    }
    
    func schoolsViewController(viewController: SchoolsViewController, didSelectSchool school: School) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        self.profile.school = school
        self.tableView.reloadData()
    }
    
    func eventsViewController(viewController: EventsViewController, didSelectEvent event: Event) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        self.profile.event = event
        self.tableView.reloadData()
    }

    @IBAction func createButtonTapped(sender: UIButton) {
        
        self.view.firstResponder()?.resignFirstResponder()

        self.createButton.enabled = true
        self.createButton.setTitle("", forState: UIControlState.Normal)
        self.activityIndicator.startAnimating()

        self.sessionTask?.cancel()
        self.sessionTask = self.profile.create { (error) in

            self.createButton.enabled = true
            self.createButton.setTitle(NSLocalizedString("Create", comment: ""), forState: UIControlState.Normal)
            self.activityIndicator.stopAnimating()

            if let error = error {
                let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
                    
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}
