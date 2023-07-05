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
}

enum UploadAadharRouter {
    case upload(image: String)
}

extension UploadAadharRouter : APIRouter {
    
    var path: String {
        return "/uhi/webhook/postorder/analyseDoc"
    }
    
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
