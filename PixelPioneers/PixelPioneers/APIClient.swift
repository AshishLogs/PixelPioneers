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
    private static func performRequest<T:Decodable>(route:URLRequestConvertible, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        return AF.request(route).validate(statusCode: 200..<410)
            .responseDecodable (decoder: decoder){ (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let responsess):
                    if let d = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: d, options: []) as? [String : Any]
                            print(json)
                        } catch {
                            print("errorMsg")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                completion(response.result)
        }
    }
    
    static func uploadImage(base64Image: String,completion:@escaping (AFResult<UploadResponse>)->Void){
        do {
            let homeRouter = try UploadRouter.upload(image: base64Image).asURLRequest()
            performRequest(route: homeRouter, completion:completion )
        }
        catch (let error){
            print(error)
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
            return ["docType":"kycIdDocument", "base64Data": image]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
}
