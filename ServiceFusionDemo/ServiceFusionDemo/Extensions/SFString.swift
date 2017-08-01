//
//  SFString.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 8/1/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import Foundation

extension String {
    
    public var isNumeric: Bool {
        return  rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    public var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count && self.characters.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    public func date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    public func date(withStyle style: DateFormatter.Style = .medium) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.date(from: self)
    }
}
