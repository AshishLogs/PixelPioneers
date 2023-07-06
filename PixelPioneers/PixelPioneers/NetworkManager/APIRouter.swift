//
//  APIRouter.swift
//  Jaarx
//
//  Created by Sumit Kumar on 14/06/20.
//  Copyright © 2020 Sushant Alone. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRouter: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
}

extension APIRouter {
    
    var baseURL: String {
        return "https://digitalproxy-staging.paytm.com"
    }
    
    var path : String {
        return "/uhi/webhook/postorder/analyseDoc"
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    var version: String {
        return ""
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var url: URL {
           switch httpMethod {
           case .get:
               var parameterString : String?
               if (parameters != nil) {
                   parameterString = Helper.makeUrlWithParameters(parameters!)
               }
               return URL.init(string: self.baseURL + self.path + (parameterString ?? ""))!
           default:
               return URL.init(string: self.baseURL + self.path)!
           }
       }

       
       func asURLRequest() throws -> URLRequest {
           var urlRequest = URLRequest.init(url: self.url)
           urlRequest.httpMethod = httpMethod.rawValue
            urlRequest.headers = headers!
           if httpMethod == .post{
               if let parameters = parameters {
                   let jsonData = Helper.makeHttpBodyWithParameters(parameters)
                   let bcf = ByteCountFormatter()
                   bcf.allowedUnits = [.useMB]
                   bcf.countStyle = .file
                   if let m = jsonData {
                       let string = bcf.string(fromByteCount: Int64(m.count))
                       print(jsonData)
                   }
                   if let bodyData = jsonData {
                       urlRequest.httpBody = bodyData
                   }
               }
           }
           return urlRequest
       }
}

struct Helper {
    static func makeUrlWithParameters(_ parameters :Parameters) -> String {
        do {
                              
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictFromJSON = decoded as? [String:String] {
            print(dictFromJSON)
            let jsonString = dictFromJSON.reduce("") { "\($0)\($1.0)=\($1.1)&" }
                return String(jsonString.dropLast())
            } else {
                return ""
            }
                              
        } catch {
            return ""
        }
    }
    
    static func makeHttpBodyWithParameters(_ parameters:Parameters) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
    
    static func loadJson(filename fileName: String) -> [String:Any]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
               let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                          print(jsonResult)
                    return jsonResult
                }

            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
