//
//  InvoiceModel.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import Foundation
import Alamofire


enum InvoiceRouter {
    case upload(image: String)
}

extension InvoiceRouter : APIRouter {
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .upload(let image):
            return ["docType":"invoice", "base64Data": image]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
}
