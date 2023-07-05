//
//  Utility.swift
//  Hackathon
//
//  Created by Sushant on 05/07/23.
//

import Foundation
import UIKit


public class Utility {
    static func convertImageToBase64(image : UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 0.3) {
            return imageData.base64EncodedString()
        }
        return nil
    }
}
