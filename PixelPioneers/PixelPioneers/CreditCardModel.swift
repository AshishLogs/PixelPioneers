//
//  CreditCardModel.swift
//  PixelPioneers
//
//  Created by Ashish Singh on 05/07/23.
//

import UIKit
import Alamofire

struct CreditCardModel: Codable {
    let cardHolderName: CardHolderName?
    let cardNumber: CardNumber?
    let docType: String?
    let expDate: ExpirationDate?
}

struct CardHolderName: Codable {
    let value: String?
}

struct CardNumber: Codable {
    let value: String?
}

struct ExpirationDate: Codable {
    let month: String?
    let year: String?
}

enum UploadCreditCardRouter {
    case upload(image: String)
}

extension UploadCreditCardRouter : APIRouter {
    
    var path: String {
        return "/uhi/webhook/postorder/analyseDoc"
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .upload(let image):
            return ["docType":"creditCard", "base64Data": image]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
}
