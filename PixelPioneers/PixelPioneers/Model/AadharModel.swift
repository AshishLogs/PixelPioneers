//
//  AadharModel.swift
//  PixelPioneers
//
//  Created by Ashish Singh on 05/07/23.
//

import UIKit
import Alamofire

struct AadharModel: Codable {
    let DateOfBirth: String?
    let DocumentNumber: String?
    let FirstName: String?
    let LastName: String?
    
    var list : [OCRValues] {
        return [OCRValues(key: "First Name", value: self.FirstName),
                OCRValues(key: "Last Name", value: self.LastName),
                OCRValues(key: "Document Number", value: self.DocumentNumber),
                OCRValues(key: "Date Of Birth", value: self.DateOfBirth)].filter({$0.value != nil })
    }
    
}

enum UploadAadharRouter {
    case upload(image: String)
}

extension UploadAadharRouter : APIRouter {
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .upload(let image):
            return ["docType":"kycIdDocument", "base64Data": image]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
}
