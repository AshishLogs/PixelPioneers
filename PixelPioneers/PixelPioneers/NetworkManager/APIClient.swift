//
//  APIClient.swift
//  Jaarx
//
//  Copyright © 2020 Sushant Alone. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseModel : Codable {
    var data: Data? { get set }
}

class APIClient {
    
    static let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    @discardableResult
    private static func performRequest<T:BaseModel>(route:URLRequestConvertible, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        if let v = UIApplication.shared.windows.last?.rootViewController?.presentedViewController {
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            v.present(alert, animated: true, completion: nil)
        }
        return AF.request(route).validate(statusCode: 200..<410)
               .responseData { response in
                alert.dismiss(animated: true)
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        var model = try decoder.decode(T.self, from: data)
                        model.data = data
                        completion(.success(model))
                    } catch {
                        completion(.failure(AFError.explicitlyCancelled))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    static func uploadAadharImage(base64Image: String,completion:@escaping (AFResult<AadharModel>)->Void) {
        do {
            let uploadRouter = try UploadAadharRouter.upload(image: base64Image).asURLRequest()
            performRequest(route: uploadRouter, completion:completion)
        }
        catch (_){
            completion(.failure(AFError.explicitlyCancelled))
        }
    }
    
    static func uploadCreditCardImage(base64Image: String,completion:@escaping (AFResult<CreditCardModel>)->Void){
        do {
            let uploadRouter = try UploadCreditCardRouter.upload(image: base64Image).asURLRequest()
            performRequest(route: uploadRouter, completion:completion)
        }
        catch (_){
            completion(.failure(AFError.explicitlyCancelled))
        }
    }
    
    static func uploadElectrictyImage(base64Image: String,completion:@escaping (AFResult<EBModel>)->Void){
        do {
            let uploadRouter = try ElectricityBillRouter.upload(image: base64Image).asURLRequest()
            performRequest(route: uploadRouter, completion:completion)
        }
        catch (_){
            completion(.failure(AFError.explicitlyCancelled))
        }
    }
    
    static func uploadInvoiceImage(base64Image: String,completion:@escaping (AFResult<InvoiceModel>)->Void){
        do {
            let uploadRouter = try InvoiceRouter.upload(image: base64Image).asURLRequest()
            performRequest(route: uploadRouter, completion:completion)
        }
        catch (_){
            completion(.failure(AFError.explicitlyCancelled))
        }
    }
    
    static func uploadMedicalDocumentImage(base64Image: String,completion:@escaping (AFResult<InvoiceModel>)->Void){
        do {
            let uploadRouter = try MedicalRouter.upload(image: base64Image).asURLRequest()
            performRequest(route: uploadRouter, completion:completion)
        }
        catch (_){
            completion(.failure(AFError.explicitlyCancelled))
        }
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
