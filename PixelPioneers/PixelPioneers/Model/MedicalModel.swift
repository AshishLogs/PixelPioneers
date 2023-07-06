//
//  MedicalModel.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import Foundation
import Alamofire


enum MedicalRouter {
    case upload(image: String)
}

extension MedicalRouter : APIRouter {
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .upload(let image):
            return ["docType":"medical", "base64Data": image]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
}
