//
//  APIClient.swift
//  Jaarx
//
//  Created by Sumit Kumar on 14/06/20.
//  Copyright © 2020 Sushant Alone. All rights reserved.
//

import Foundation
import Alamofire
class APIClient {
    @discardableResult
    private static func performRequest(route:URLRequestConvertible, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<Data, Error>)->Void) -> DataRequest {
        return AF.request(route).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func uploadImage(base64Image: String,completion:@escaping (Result<Data, Error>)->Void){
        do {
            let uploadRouter = try UploadRouter.upload(image: base64Image).asURLRequest()
            performRequest(route: uploadRouter, completion:completion)
        }
        catch (let error){
            completion(.failure(error))
        }
    }
    
}

struct  UploadResponse : Codable {
    
}

enum UploadRouter {
    case upload(image: String)
}

extension UploadRouter : APIRouter {
    
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

extension Data {
    func toDictionary() -> [String: Any]? {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String: Any] {
                return dictionary
            }
        } catch {
            print("Error converting data to dictionary: \(error)")
        }
        return nil
    }
}
