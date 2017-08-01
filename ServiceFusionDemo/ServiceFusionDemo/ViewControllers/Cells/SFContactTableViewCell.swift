//
//  SFContactTableViewCell.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 7/31/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import UIKit

class SFContactTableViewCell: UITableViewCell {
    
    fileprivate let imageSize = CGSize(width: 40, height: 40)
    
    public func configureCell(withContact contact: SFContact) {
        if let firstName = contact.firstName, let lastName = contact.lastName {
            textLabel?.text = "\(firstName) \(lastName)"
        }
        if let photoUrl = contact.photoUrl, let image = UIImage.loadImageFromPath(photoUrl) {
            imageView?.image = image.resizedImage(newSize: imageSize)
        } else {
            imageView?.image = UIImage(named: "profile")?.resizedImage(newSize: imageSize)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.clipsToBounds = true
        imageView?.layer.cornerRadius = imageSize.height / 2
        imageView?.setNeedsDisplay()
    }
}
