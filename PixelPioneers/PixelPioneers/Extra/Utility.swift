//
//  Utility.swift
//  Hackathon
//
//  Created by Sushant on 05/07/23.
//

import Foundation
import UIKit


public class Utility {
    class func convertImageToBase64(image : UIImage) -> String? {
        if let imgData = Utility.compressImage(image, maxSizeInBytes: 3000000)  {
            let base64 = imgData.base64EncodedString()
            return base64
        }
        return nil
    }
    
    class func compressImage(_ image: UIImage, maxSizeInBytes: Int) -> Data? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        var compressionQuality: CGFloat = 1.0
        var compressedData = imageData
        
        while compressedData.count > maxSizeInBytes && compressionQuality > 0.0 {
            compressionQuality -= 0.1
            
            if let newImageData = image.jpegData(compressionQuality: compressionQuality) {
                compressedData = newImageData
            }
        }
        
        return compressedData
    }

    
   class func resizeImage(image: UIImage) -> UIImage? {
       
       let maxWidth: CGFloat = UIScreen.main.bounds.width
       let maxHeight: CGFloat = UIScreen.main.bounds.height
       let maxSizeInBytes = 3 * 1024 * 1024
       
       var compression: CGFloat = 1.0
       let maxCompression: CGFloat = 0.1
       var imageData = image.jpegData(compressionQuality: compression)
       
       while let data = imageData, data.count > maxSizeInBytes && compression > maxCompression {
           compression -= 0.1
           imageData = image.jpegData(compressionQuality: compression)
       }
       
       guard let resizedData = imageData, let resizedImage = UIImage(data: resizedData) else {
           return nil
       }
       
       let originalWidth = image.size.width
       let originalHeight = image.size.height
       let scaleFactor: CGFloat

       if originalWidth > originalHeight {
           scaleFactor = maxWidth / originalWidth
       } else {
           scaleFactor = maxHeight / originalHeight
       }

       let newWidth = originalWidth * scaleFactor
       let newHeight = originalHeight * scaleFactor

       UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 1.0)
       resizedImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return newImage
   }
    
}

public enum DocumentType : String  {
    case medical = "Read Medical Document"
    case invoice = "Read Invoice"
    case card    = "Read Credit/Debit Card"
    case electricity = "Read Electricity Bill"
    case adhar   = "Aadhar KYC"
}
