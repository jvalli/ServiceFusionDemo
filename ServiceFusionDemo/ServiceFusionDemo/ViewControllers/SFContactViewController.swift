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
    
    fileprivate let imageNameLength = 42
    fileprivate let defaultHeightConstraintValue: CGFloat = 20
    fileprivate let keyboardHeightConstraintValue: CGFloat = -130
    fileprivate let datePicker = UIDatePicker()
    fileprivate let imagePicker = UIImagePickerController()
    
    // MARK: - # Variables
    
    @IBOutlet weak var buttonPhoto: UIButton!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldDateOfBirth: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textFieldZipCode: UITextField!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    var contactController: SFContactController?
    var imageWasChanged = false
    
    // MARK: - # Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SFContactViewController.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        buttonPhoto.clipsToBounds = true
        buttonPhoto.layer.cornerRadius = buttonPhoto.bounds.size.height / 2
        
        imagePicker.delegate = self
        
        configureDateOfBirthPicker()
        configurePhoneNumberToolbar()
        
        if let contact = contactController?.getSelectedContact() {
            loadScreenValues(withContact: contact)
        } else {
            clearScreenValues()
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
        imageWasChanged = false
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
        if let photoUrl = contact.photoUrl, let image = UIImage.loadImageFromPath(photoUrl), !imageWasChanged {
            buttonPhoto.setBackgroundImage(image, for: .normal)
        }
    }
    
    @objc fileprivate func doneTextFieldDateOfBirth() {
        let selectedDate = datePicker.date
        textFieldDateOfBirth.text = selectedDate.dateString()
        textFieldDateOfBirth.resignFirstResponder()
    }
    
    @objc fileprivate func doneTextFieldPhoneNumber() {
        textFieldPhoneNumber.resignFirstResponder()
    }
    
    @objc fileprivate func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightConstraint.constant = self.defaultHeightConstraintValue
            } else {
                self.keyboardHeightConstraint.constant = self.keyboardHeightConstraintValue
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                                self.view.layoutIfNeeded()
                           },
                           completion: nil)
        }
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
    
    fileprivate func presentImagePicker(withMode mode: UIImagePickerControllerSourceType) {
        
        if !UIImagePickerController.isSourceTypeAvailable(mode) {
            return
        }
        imagePicker.sourceType = mode
        imagePicker.allowsEditing = false
        if mode == .camera {
            imagePicker.cameraCaptureMode = .photo
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func updateContact() {
        var photoUrl = ""
        if imageWasChanged, let image = buttonPhoto.backgroundImage(for: .normal), let path = UIImage.saveImageToDocumentDirectory(image, String.randomString(length: imageNameLength).appending(".jpg")) {
            if contactController?.getSelectedContact()?.photoUrl != nil {
                UIImage.deleteImageFromPath(contactController!.getSelectedContact()!.photoUrl!)
            }
            photoUrl = path
        } else if contactController?.getSelectedContact()?.photoUrl != nil {
            photoUrl = contactController!.getSelectedContact()!.photoUrl!
        }
        contactController?.updateSelectedContact(firstName: textFieldFirstName.text!, lastName: textFieldLastName.text!, dateOfBirth: textFieldDateOfBirth.text!, phoneNumber: textFieldPhoneNumber.text!, zipCode: textFieldZipCode.text!, photoUrl: photoUrl, handler: { success, errors in
            if success {
                self.contactController?.removeSelectedContact()
                self.navigationController?.popViewController(animated: true)
            } else {
                self.handleContactErrors(errors)
            }
        })
    }
    
    fileprivate func createContact() {
        var photoUrl = ""
        if let image = buttonPhoto.backgroundImage(for: .normal), let path = UIImage.saveImageToDocumentDirectory(image, String.randomString(length: imageNameLength).appending(".jpg")) {
            photoUrl = path
        }
        contactController?.createNewContact(firstName: textFieldFirstName.text!, lastName: textFieldLastName.text!, dateOfBirth: textFieldDateOfBirth.text!, phoneNumber: textFieldPhoneNumber.text!, zipCode: textFieldZipCode.text!, photoUrl: photoUrl, handler: { success, errors in
            if success {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.handleContactErrors(errors)
            }
        })
    }
    
    // MARK: - # IBActions
    
    @IBAction func onClickButtonPhoto() {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let actionTakePhoto = UIAlertAction(title: "Take a Photo", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.presentImagePicker(withMode: .camera)
            })
            menu.addAction(actionTakePhoto)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let actionChooseFromLibrary = UIAlertAction(title: "Choose from Library", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.presentImagePicker(withMode: .photoLibrary)
            })
            menu.addAction(actionChooseFromLibrary)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        menu.addAction(actionCancel)
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func onClickButtonCancel() {
        contactController?.removeSelectedContact()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickButtonSave() {
        if contactController?.getSelectedContact() != nil {
            updateContact()
        } else {
            createContact()
        }
    }
}

extension SFContactViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SFContactViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageWasChanged = true
            buttonPhoto.setBackgroundImage(editedImage, for: .normal)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageWasChanged = true
            buttonPhoto.setBackgroundImage(image, for: .normal)
        }
        buttonPhoto.setNeedsDisplay()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
