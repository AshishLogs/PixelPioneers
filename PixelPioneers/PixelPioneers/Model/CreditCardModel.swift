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
    
    var list : [OCRValues] {
        return [OCRValues(key: "Card Holder Name", value: self.cardHolderName?.value),
                OCRValues(key: "Card Number", value: self.cardNumber?.value),
                OCRValues(key: "Expiry Date", value: [self.expDate?.month, self.expDate?.year].compactMap({$0}).joined(separator:" / "))].filter({$0.value != nil && ($0.value ?? "").count > 0 })
    }
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
