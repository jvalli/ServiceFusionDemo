//
//  SFAlertView.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 8/1/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import UIKit

class SFAlertView {
    
    static func displaySingleAlert(title: String, message: String, sender: AnyObject) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let viewController = sender as? UIViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func displayErrorAlert(message: String, sender: AnyObject) {
        SFAlertView.displaySingleAlert(title: "Error!", message: message, sender: sender)
    }
}
