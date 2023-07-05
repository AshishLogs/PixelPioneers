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
                case .success(let response):
                    print("Response is successful = \(response) for url \(String(describing: route.urlRequest?.url!))")
                case .failure(let error):
                    print(error)
                }
                completion(response.result)
        }
    }
    static func getHomeData(completion:@escaping (AFResult<HomeResponse>)->Void){
        do {
            let homeRouter = try HomeRouter.home.asURLRequest()
            performRequest(route: homeRouter, completion:completion )
            
        }
        catch (let error){
            print(error)
        }
    }
    
    static func addOrderWith(params:[String:Any], completion:@escaping (AFResult<AddOrderResponse>)->Void){
           do {
            let userRouter = try UserRouter.addOrder(params: params).asURLRequest()
               performRequest(route: userRouter, completion:completion )
           }
           catch (let error){
               print(error)
           }
       }
    static func registerDeviceWith(params:[String:Any], completion:@escaping (AFResult<GenericResponse>)->Void){
        do {
         let userRouter = try UserRouter.registerDevice(params: params).asURLRequest()
            performRequest(route: userRouter, completion:completion )
        }
        catch (let error){
            print(error)
        }
    }
    static func bookTableWith(params:[String:Any], completion:@escaping (AFResult<GenericResponse>)->Void){
        do {
         let restaurantRouter = try RestaurantRouter.bookTableWith(params: params).asURLRequest()
            performRequest(route: restaurantRouter, completion:completion )
        }
        catch (let error){
            print(error)
        }
    }
    static func updateBookingWith(params:[String:Any], completion:@escaping (AFResult<GenericResponse>)->Void){
        do {
         let restaurantRouter = try RestaurantRouter.updateBookingWith(params: params).asURLRequest()
            performRequest(route: restaurantRouter, completion:completion )
        }
        catch (let error){
            print(error)
        }
    }
    
    static func setFavoriteStatusForUser(userId : String, resId : String, status:Bool, completion:@escaping (AFResult<GenericResponse>) -> Void){
        do {
            let restaurantRouter = try RestaurantRouter.setFavorite(userId: userId, resId: resId, status: status).asURLRequest()
            performRequest(route: restaurantRouter, completion:completion)
        }
        catch (let error){
            print(error)
        }
    }
    
    static func requestOTPForPhoneNumber(user : User, completion:@escaping (AFDataResponse<Data>) -> Void) {
            do {
                let requestOTPRouter = try LoginRouter.requestOTP(phoneNumber: user.phoneNumber, countrycode: "91").asURLRequest()
                AF.request(requestOTPRouter).responseData(completionHandler: completion)
            } catch (let error){
                print(error)
            }
    }
    
    static func signUpWithPhoneNumber(user : User, completion:@escaping (AFResult<Token>) -> Void){
        do {
            let loginRouter = try LoginRouter.signUp(phoneNumber: user.phoneNumber, otp: user.otp, device_token: user.device_token, device_os: user.device_os, firstName: user.firstName, lastName: user.lastName, email: user.email).asURLRequest()
            performRequest(route: loginRouter, completion: completion)
        } catch (let error){
            print(error)
        }
    }
    
    static func signInWithPhoneNumber(user : User,completion:@escaping (AFResult<Token>) -> Void){
        do {
            let signInRouter = try LoginRouter.signIn(phoneNumber: user.phoneNumber, otp: user.otp, device_token: user.device_token).asURLRequest()
            performRequest(route: signInRouter, completion: completion)
        } catch (let error) {
            print(error)
        }
    }
    
    static func searchDataWithText(text : String, completion:@escaping (AFResult<SearchReponse>) -> Void){
        do {
            let searchRouter = try SearchRouter.search(searchText: text).asURLRequest()
            performRequest(route: searchRouter, completion: completion)
        } catch (let error) {
            print(error)
        }
    }
    static func getRestaurantDetailFor(resId : String, completion:@escaping (AFResult<RestaurantDetailResponse>)->Void){
        do {
            let restaurantRouter = try RestaurantRouter.getRestaurantDetailFor(id: resId).asURLRequest()
            performRequest(route: restaurantRouter, completion: completion)
        }
        catch (let error){
            print(error)
        }
    }
}

