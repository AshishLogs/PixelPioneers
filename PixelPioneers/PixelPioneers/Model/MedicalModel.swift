//
//  MedicalModel.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import Foundation
import Alamofire

struct MBModel: Codable, BaseModel {
    let instituteName, tag, date: String?
    var data: Data?
    var list : [OCRValues] {
        return [OCRValues(key: "Institution Name", value: self.instituteName),
                OCRValues(key: "Tag", value: self.tag),
                OCRValues(key: "Date", value: self.date)].filter({$0.value != nil && ($0.value ?? "").count > 0 })
    }
}


enum MedicalRouter {
    case upload(image: String)
}

extension MedicalRouter : APIRouter {
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .upload(let image):
            return ["docType":"medicalReport", "base64Data": image]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
}
