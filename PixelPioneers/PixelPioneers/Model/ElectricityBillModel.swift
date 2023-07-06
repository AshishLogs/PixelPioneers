//
//  ElectricityBillModel.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import Foundation
import Alamofire


enum ElectricityBillRouter {
    case upload(image: String)
}

extension ElectricityBillRouter : APIRouter {
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .upload(let image):
            return ["docType":"eb", "base64Data": image]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
}
