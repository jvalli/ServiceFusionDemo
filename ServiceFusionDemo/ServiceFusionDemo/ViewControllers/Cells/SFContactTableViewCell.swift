//
//  SFContactTableViewCell.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 7/31/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import UIKit

class SFContactTableViewCell: UITableViewCell {
    
    public func configureCell(withContact contact: SFContact) {
        if let firstName = contact.firstName, let lastName = contact.lastName {
            textLabel?.text = "\(firstName) \(lastName)"
        }
    }
}
