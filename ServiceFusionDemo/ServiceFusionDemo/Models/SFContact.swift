//
//  SFContact.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 7/31/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import Foundation
import CoreData


class SFContact: NSManagedObject {

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var dateOfBirth: NSDate?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var zipCode: String?

}
