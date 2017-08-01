//
//  SFConstants.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 7/31/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import Foundation

enum ContactErrorType {
    case emptyFirstName
    case emptyLastName
    case emptyDateOfBirth
    case dateOfBirthIsInFuture
    case emptyPhoneNumber
    case phoneNumberInvalid
    case emptyZipCode
}

class SFConstants {
    
    public struct CoreData {
        public static let modelName = "SFDataModel"
    }
    
    public struct CellIdentifiers {
        public static let contact = "SFContactTableViewCell"
    }
    
    public struct Segues {
        public static let homeVC = "SFHomeViewController"
        public static let contactVC = "SFContactViewController"
    }
}
