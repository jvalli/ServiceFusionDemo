//
//  SFContactController.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 7/31/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import Foundation
import CoreData

class SFContactController: NSObject {
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<SFContact>
    fileprivate var selectedContact: SFContact? = nil
    
    init(withFetchedResultsControllerDelegate delegate: NSFetchedResultsControllerDelegate) {
        
        let request = NSFetchRequest<SFContact>(entityName: "SFContact")
        let firstNameSort = NSSortDescriptor(key: "firstName", ascending: true)
        let lastNameSort = NSSortDescriptor(key: "lastName", ascending: true)
        request.sortDescriptors = [firstNameSort, lastNameSort]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: SFCoreDataHelper.shared.getManagedObjectContext(), sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = delegate
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        super.init()
    }
    
    // MARK: - # Private Functions
    
    fileprivate func validateContact(firstName: String, lastName: String, dateOfBirth: String, phoneNumber: String, zipCode: String) -> [ContactErrorType] {
        var result = [ContactErrorType]()
        if firstName.isEmpty {
            print("firstName is empty")
            result.append(.emptyFirstName)
        }
        if lastName.isEmpty {
            print("lastName is empty")
            result.append(.emptyLastName)
        }
        if dateOfBirth.isEmpty {
            print("dateOfBirth is empty")
            result.append(.emptyDateOfBirth)
        } else if let date = dateOfBirth.date(), date.isInFuture {
            print("dateOfBirth is in future")
            result.append(.dateOfBirthIsInFuture)
        }
        if phoneNumber.isEmpty {
            print("phoneNumber is empty")
            result.append(.emptyPhoneNumber)
        } else if !phoneNumber.isNumeric || !phoneNumber.isPhoneNumber {
            print("phoneNumber is invalid")
            result.append(.phoneNumberInvalid)
        }
        if zipCode.isEmpty {
            print("zipCode is empty")
            result.append(.emptyZipCode)
        }
        return result
    }
    
    // MARK: - # Public Functions
    
    public func getFetchedResultsController() -> NSFetchedResultsController<SFContact> {
        return fetchedResultsController
    }
    
    public func createNewContact(firstName: String, lastName: String, dateOfBirth: String, phoneNumber: String, zipCode: String, photoUrl: String, handler: (_ success: Bool, _ errors: [ContactErrorType]) -> ()) {
        
        var success = false
        let errors = validateContact(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber, zipCode: zipCode)
        defer {
            handler(success, errors)
        }
        guard errors.count == 0 else {
            return
        }
        
        if let contact = NSEntityDescription.insertNewObject(forEntityName: "SFContact", into: SFCoreDataHelper.shared.getManagedObjectContext()) as? SFContact {
            contact.firstName = firstName
            contact.lastName = lastName
            contact.dateOfBirth = dateOfBirth.date() as NSDate?
            contact.phoneNumber = phoneNumber
            contact.zipCode = zipCode
            contact.photoUrl = photoUrl
            
            do {
                try SFCoreDataHelper.shared.getManagedObjectContext().save()
                success = true
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    public func deleteContact(_ contact: SFContact, handler: (_ success: Bool) -> ()) {
        
        var success = false
        defer {
            handler(success)
        }
        
        SFCoreDataHelper.shared.getManagedObjectContext().delete(contact)
        do {
            try SFCoreDataHelper.shared.getManagedObjectContext().save()
            success = true
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    public func setSelectedContact(contact: SFContact) {
        selectedContact = contact
    }
    
    public func getSelectedContact() -> SFContact? {
        return selectedContact
    }
    
    public func removeSelectedContact() {
        selectedContact = nil
    }
    
    public func updateSelectedContact(firstName: String, lastName: String, dateOfBirth: String, phoneNumber: String, zipCode: String, photoUrl: String, handler: (_ success: Bool, _ errors: [ContactErrorType]) -> ()) {
        
        var success = false
        let errors = validateContact(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber, zipCode: zipCode)
        defer {
            handler(success, errors)
        }
        guard errors.count == 0 else {
            return
        }
        
        do {
            selectedContact?.firstName = firstName
            selectedContact?.lastName = lastName
            selectedContact?.dateOfBirth = dateOfBirth.date() as NSDate?
            selectedContact?.phoneNumber = phoneNumber
            selectedContact?.zipCode = zipCode
            selectedContact?.photoUrl = photoUrl
            try SFCoreDataHelper.shared.getManagedObjectContext().save()
            success = true
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}
