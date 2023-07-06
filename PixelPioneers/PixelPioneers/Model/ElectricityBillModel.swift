//
//  ElectricityBillModel.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import Foundation
import Alamofire

struct EBModel: Codable, BaseModel {
    let amount, billingUnit, consumerID,electricityBoard,pincode ,state: String?
    var data: Data?
    
    enum CodingKeys: String, CodingKey {
        case amount, billingUnit
        case consumerID = "consumerId"
        case electricityBoard
        case state
        case pincode
    }
    
    var list : [OCRValues] {
        return [OCRValues.init(key: "EB Board", value: self.electricityBoard),
                OCRValues.init(key: "Consumer ID", value: self.consumerID),
                OCRValues.init(key: "Amount", value: self.amount),
                OCRValues.init(key: "Pincode", value: self.pincode),
                OCRValues.init(key: "Billing Unit", value: self.billingUnit)].filter({$0.value != nil && ($0.value ?? "").count > 0 })
    }

    
}


enum ElectricityBillRouter {
    case upload(image: String)
}

extension ElectricityBillRouter : APIRouter {
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .upload(let image):
            return ["docType":"eb2", "base64Data": image]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
}
