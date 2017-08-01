//
//  SFDate.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 8/1/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import Foundation

extension Date {
    
    public var isInFuture: Bool {
        return self > Date()
    }
    
    public func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}
