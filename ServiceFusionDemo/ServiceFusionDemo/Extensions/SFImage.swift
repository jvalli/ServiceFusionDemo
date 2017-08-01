//
//  SFImage.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 8/1/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func saveImageToDocumentDirectory(_ image: UIImage, _ imageName: String) -> String? {
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            let fileName = documentsDirectory.appendingPathComponent(imageName)
            do {
                try imageData.write(to: fileName)
                print("Saving attachment successful!")
                return fileName.path
            } catch let error as NSError {
                print("Error saving attachment to documents directory. Error: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    static func loadImageFromPath(_ imagePath: String) -> UIImage? {
        if FileManager.default.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)
        }
        return nil
    }
    
    static func deleteImageFromPath(_ imagePath: String) {
        if FileManager.default.fileExists(atPath: imagePath) {
            do {
                try FileManager.default.removeItem(atPath: imagePath)
                print("Deleting attachment successful!")
            } catch let error as NSError {
                print("Error deleting attachment from documents directory. Error: \(error.localizedDescription)")
            }
        } else {
            print("File does not exists!")
        }
    }
}
