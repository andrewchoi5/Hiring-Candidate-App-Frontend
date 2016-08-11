//
//  CreateProfileViewController.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class CreateProfileViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, EventsViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!

    @IBOutlet var tableViewBottom: NSLayoutConstraint!

    var datePicker: UIDatePicker!
    var textPicker: UIPickerView!
    var keyboardToolbar: UIToolbar!
    
    var firstNameTextField: UITextField!
    var lastNameTextField: UITextField!
    var emailTextField: UITextField!
    var cityTextField: UITextField!
    var eventTextField: UITextField!
    
    var profile: Profile = Profile(data: NSDictionary())
    
    var eventNames = ["University", "Somewhere Else", "IBM"]
    var cityNames = ["Montreal", "Vancouver", "Toronto"]
    var universityNames = ["University of British Columbia", "University of Toronto", "University of Waterloo"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Candidate Information", comment: "")

        self.datePicker = UIDatePicker()
        
        self.textPicker = UIPickerView()
        self.textPicker.dataSource = self
        self.textPicker.delegate = self
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(CreateProfileViewController.doneButtonTapped(_:)))
        
        self.createButton.backgroundColor = UIColor.primaryButtonColor()

        self.keyboardToolbar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
        self.keyboardToolbar.setItems([flexibleSpace, doneButton], animated: false)
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

    func doneButtonTapped(sender: UIBarButtonItem) {
        
        if self.textPicker.tag == 3 {
            self.profile.city = self.cityNames[self.textPicker.selectedRowInComponent(0)]
        }
        
        if self.textPicker.tag == 4 {
            self.profile.event?.name = self.eventNames[self.textPicker.selectedRowInComponent(0)]
        }
        
//        if self.datePicker.tag == 6 {
//            self.profile.eventDate = self.datePicker.date
//        }
        
        self.tableView.reloadData()
        self.view.firstResponder()?.resignFirstResponder()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CreateProfileCell", forIndexPath: indexPath) as! CreateProfileCell

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        if indexPath.row == 0 {
            
            cell.accessoryView = nil
            
            cell.textField.inputView = nil
            
            cell.textField.autocapitalizationType = UITextAutocapitalizationType.Words
            cell.textField.autocorrectionType = UITextAutocorrectionType.No
            cell.textField.spellCheckingType = UITextSpellCheckingType.No
            cell.textField.returnKeyType = UIReturnKeyType.Next
            
            cell.textField.placeholder = NSLocalizedString("First Name", comment: "")
            cell.textField.text = self.profile.firstname
            
            firstNameTextField = cell.textField

        } else if indexPath.row == 1 {
            
            cell.accessoryView = nil
            
            cell.textField.inputView = nil
            
            cell.textField.autocapitalizationType = UITextAutocapitalizationType.Words
            cell.textField.autocorrectionType = UITextAutocorrectionType.No
            cell.textField.spellCheckingType = UITextSpellCheckingType.No
            cell.textField.returnKeyType = UIReturnKeyType.Next

            cell.textField.placeholder = NSLocalizedString("Last Name", comment: "")
            cell.textField.text = self.profile.lastname
            
            lastNameTextField = cell.textField
            
        } else if indexPath.row == 2 {
            
            cell.accessoryView = nil
            
            cell.textField.inputView = nil
            
            cell.textField.autocapitalizationType = UITextAutocapitalizationType.None
            cell.textField.autocorrectionType = UITextAutocorrectionType.No
            cell.textField.spellCheckingType = UITextSpellCheckingType.No
            cell.textField.returnKeyType = UIReturnKeyType.Next


            cell.textField.placeholder = NSLocalizedString("Email", comment: "")
            cell.textField.keyboardType = UIKeyboardType.EmailAddress
            cell.textField.text = self.profile.email
            
            emailTextField = cell.textField
            
        } else if indexPath.row == 3 {
            
            cell.accessoryView = UIImageView(image: UIImage(named: "Accessory"))
            
            cell.textField.inputView = self.textPicker
            
            cell.textField.inputAccessoryView = self.keyboardToolbar
            cell.textField.placeholder = NSLocalizedString("City", comment: "")
            cell.textField.text = self.profile.city
            
            cityTextField = cell.textField
            
        } else if indexPath.row == 4 {

            cell.accessoryView = UIImageView(image: UIImage(named: "Accessory"))

            cell.textField.accessibilityIdentifier = "Event"
            
            cell.textField.userInteractionEnabled = false
            cell.textField.enabled = false
            cell.textField.placeholder = NSLocalizedString("Event", comment: "")
            
            cell.textField.text = self.profile.event?.name
            
            eventTextField = cell.textField

        } else if indexPath.row == 5 {

            cell.hidden = true
            
        }
//        else if indexPath.row == 6 {
//
//            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//
//            cell.textField.inputView = self.datePicker
//            cell.textField.inputAccessoryView = self.keyboardToolbar
//            cell.textField.placeholder = NSLocalizedString("Event Date", comment: "")
//            
//            if let date = self.profile.eventDate {
//                cell.textField.text = dateFormatter.stringFromDate(date)
//            } else {
//                cell.textField.text = nil
//            }
//        }
        
        cell.textField.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 4 {
            
            let eventsViewController = UIStoryboard.viewController("EventsViewController") as! EventsViewController
            eventsViewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: eventsViewController)
            self.presentViewController(navigationController, animated: true, completion: nil)

        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 5 {
            return 0
        }
        return tableView.rowHeight
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        } else if textField == self.lastNameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == self.emailTextField {
            self.cityTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        self.datePicker.tag = textField.tag
        self.textPicker.tag = textField.tag

        if textField.tag == 3 {
            self.textPicker.selectRow(self.cityNames.indexOf(textField.text ?? "") ?? 0, inComponent: 0, animated: false)
        } else if textField.tag == 4 {
            self.textPicker.selectRow(self.eventNames.indexOf(textField.text ?? "") ?? 0, inComponent: 0, animated: false)
        }
//        else if textField.tag == 6 {
//            self.datePicker.date = self.profile.eventDate ?? NSDate()
//        }

        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            self.profile.firstname = textField.text
        } else if textField.tag == 1 {
            self.profile.lastname = textField.text
        } else if textField.tag == 2 {
            self.profile.email = textField.text
        }
        
        return true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 3 {
            return cityNames.count
        } else if pickerView.tag == 4 {
            return eventNames.count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 3 {
            return cityNames[row]
        } else if pickerView.tag == 4 {
            return eventNames[row]
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
    
    func eventsViewController(viewController: EventsViewController, didSelectEvent event: Event) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        self.profile.event = event
        self.tableView.reloadData()
    }
}
