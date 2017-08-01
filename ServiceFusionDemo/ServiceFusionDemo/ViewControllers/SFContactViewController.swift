//
//  SFContactViewController.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 7/31/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import UIKit

class SFContactViewController: UIViewController {
    
    // MARK: - # Constants
    
    fileprivate let datePicker = UIDatePicker()
    
    // MARK: - # Variables
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldDateOfBirth: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textFieldZipCode: UITextField!
    
    var contactController: SFContactController?
    
    // MARK: - # Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDateOfBirthPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearScreenValues()
        if let contact = contactController?.getSelectedContact() {
            loadScreenValues(withContact: contact)
        }
    }
    
    // MARK: - # Private Functions
    
    fileprivate func configureDateOfBirthPicker() {
        let toolBar = createNewDoneToolbar(withAction: #selector(SFContactViewController.doneTextFieldDateOfBirth))
        textFieldDateOfBirth.inputAccessoryView = toolBar
        datePicker.datePickerMode = .date
        textFieldDateOfBirth.inputView = datePicker
    }
    
    fileprivate func configurePhoneNumberToolbar() {
        let toolBar = createNewDoneToolbar(withAction: #selector(SFContactViewController.doneTextFieldPhoneNumber))
        textFieldPhoneNumber.inputAccessoryView = toolBar
    }
    
    fileprivate func createNewDoneToolbar(withAction action: Selector?) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: action)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    fileprivate func clearScreenValues() {
        textFieldFirstName.text = ""
        textFieldLastName.text = ""
        textFieldDateOfBirth.text = ""
        textFieldPhoneNumber.text = ""
        textFieldZipCode.text = ""
    }
    
    fileprivate func loadScreenValues(withContact contact: SFContact) {
        textFieldFirstName.text = contact.firstName
        textFieldLastName.text = contact.lastName
        if let date = contact.dateOfBirth as Date? {
            datePicker.date = date
            textFieldDateOfBirth.text = date.dateString()
        }
        textFieldPhoneNumber.text = contact.phoneNumber
        textFieldZipCode.text = contact.zipCode
    }
    
    @objc fileprivate func doneTextFieldDateOfBirth() {
        let selectedDate = datePicker.date
        textFieldDateOfBirth.text = selectedDate.dateString()
        textFieldDateOfBirth.resignFirstResponder()
    }
    
    @objc fileprivate func doneTextFieldPhoneNumber() {
        textFieldPhoneNumber.resignFirstResponder()
    }
    
    fileprivate func handleContactErrors(_ errors: [ContactErrorType]) {
        var message = ""
        for error in errors {
            switch error {
            case .emptyFirstName:
                message += "\nEmpty First Name"
                break
            case .emptyLastName:
                message += "\nEmpty Last Name"
                break
            case .emptyDateOfBirth:
                message += "\nEmpty Date of Birth"
                break
            case .dateOfBirthIsInFuture:
                message += "\nInvalid Date of Birth"
                break
            case .emptyPhoneNumber:
                message += "\nEmpty Phone Number"
                break
            case .phoneNumberInvalid:
                message += "\nInvalid Phone Number"
                break
            case .emptyZipCode:
                message += "\nEmpty Zip Code"
                break
            }
        }
        SFAlertView.displayErrorAlert(message: message, sender: self)
    }
    
    // MARK: - # IBActions
    
    @IBAction func onClickButtonCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickButtonSave() {
        if contactController?.getSelectedContact() != nil {
            contactController?.updateSelectedContact(firstName: textFieldFirstName.text!, lastName: textFieldLastName.text!, dateOfBirth: textFieldDateOfBirth.text!, phoneNumber: textFieldPhoneNumber.text!, zipCode: textFieldZipCode.text!, handler: { success, errors in
                if success {
                    self.contactController?.removeSelectedContact()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.handleContactErrors(errors)
                }
            })
        } else {
            contactController?.createNewContact(firstName: textFieldFirstName.text!, lastName: textFieldLastName.text!, dateOfBirth: textFieldDateOfBirth.text!, phoneNumber: textFieldPhoneNumber.text!, zipCode: textFieldZipCode.text!, handler: { success, errors in
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.handleContactErrors(errors)
                }
            })
        }
    }
}

extension SFContactViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
