//
//  Utility.swift
//  Hackathon
//
//  Created by Sushant on 05/07/23.
//

import Foundation
import UIKit
import CoreImage


public class Utility {
    class func convertImageToBase64(image : UIImage) -> String? {
        if let imgData = Utility.compressImage(image, maxSizeInBytes: 3000000)  {
            let base64 = imgData.base64EncodedString()
            return base64
        }
        return nil
    }
    
   class func enhanceImageForOCR(_ image: UIImage) -> UIImage? {
        // Convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        // Create an image context
        let context = CIContext(options: nil)
        
        // Apply a sharpening filter
        guard let sharpenFilter = CIFilter(name: "CISharpenLuminance") else {
            return nil
        }
        sharpenFilter.setValue(ciImage, forKey: kCIInputImageKey)
        sharpenFilter.setValue(0.5, forKey: kCIInputSharpnessKey) // Adjust sharpness intensity as needed
        
        // Get the output image from the filter
        guard let outputImage = sharpenFilter.outputImage else {
            return nil
        }
        
        // Render the output image
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        // Create a new UIImage with the sharpened CGImage
        let sharpenedImage = UIImage(cgImage: cgImage)
        return sharpenedImage
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
    
    func convertToBlackAndWhite(image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let processedImage = UIImage(cgImage: cgImage)
                return processedImage
            }
        }
        return nil
    }
    
    func enhanceImageSharpAndContrast(image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        let filter = CIFilter(name: "CISharpenLuminance")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(2.0, forKey: kCIInputSharpnessKey)
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let enhancedImage = UIImage(cgImage: cgImage)
                if let adjustedImage = enhancedImage.ciImage?.applyingFilter(kCIInputContrastKey) {
                    return UIImage(ciImage: adjustedImage)
                }
            }
        }
        return nil
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
    
    func fixHistogramAndIncreaseSaturation(image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        // Apply histogram adjustment
        let filter = CIFilter(name: "CIAutoHistogram")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let outputImage = filter?.outputImage {
            // Increase saturation
            let adjustedImage = outputImage.applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey: 2.0])
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(adjustedImage, from: adjustedImage.extent) {
                let processedImage = UIImage(cgImage: cgImage)
                return processedImage
            }
        }
        return nil
    }
    
}

public enum ServiceType : String  {
    case medical = "Medical Document"
    case invoice = "Invoice"
    case card    = "Credit/Debit Card"
    case electricity = "Electricity Bill"
    case adhar   = "Aadhar KYC"
    case logout  = "Logout"
    
    var message : String {
        switch self {
        case .medical:
            return "IMPORTANT \n 1. For best results, place your prescription/medical report/medical bill on a table under good lighting conditions, hold your phone straight face down and capture the photo.\n 2. You can also upload digital copy, if you have one."
        case .invoice:
            return "IMPORTANT \n 1. For best results, place your printed invoice on a table under good lighting conditions, hold your phone face down and capture the photo. \n 2. You can also upload digital copy, if you have one."
        case .card:
            return "IMPORTANT \n 1. For best results, place your debit card or credit card on a table under good lighting conditions, hold your phone face down and capture the photo.\n 2. Accepted formats include Visa, MasterCard, RuPay, American Express, Maestro, Discover, Diner’s Club and more."
        case .electricity:
            return "IMPORTANT \n 1. Please ensure the consumer ID/number and the electricity board name are visible clearly in the image.\n 2. You can also upload digital copy, if you have one."
        case .adhar:
            return "IMPORTANT \n 1. For best results, place your aadhar card on a table under good lighting conditions, hold your phone straight face down and capture the photo.\n 2. You can also upload digital copy, if you have one."
        case .logout:
            return "We are logging you out!!!"
        }
    }
    
    var imageName : String {
        switch self {
        case .medical:
            return "healthGrid"
        case .invoice:
            return "invoiceGrid"
        case .electricity: return "ebGrid"
        case .card : return "card"
        case .adhar: return "adharGrid"
        case .logout : return "logoutGrid"
        }
    }
    
}
