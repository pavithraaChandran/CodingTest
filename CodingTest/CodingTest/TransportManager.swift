//
//  TransportManager.swift
//  AJDA_B2C
//
//  Created by PTBLR-1128 on 22/11/18.
//  Copyright © 2018 Provab Technosoft Pvt. Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON


class TransportManager {
  
  static var sharedInstance = TransportManager()
  let prefs:UserDefaults = UserDefaults.standard
  fileprivate let reachabilityManger:NetworkReachabilityManager! = NetworkReachabilityManager()
  
  var isReachable: Bool!  {
    get {
      return reachabilityManger.isReachable
    }
  }
  
  func sendRequest(parameters:[String : String], url: String, method: VKMethodType, callback: @escaping (_ data: Any?, _ err: Error?)-> ()){
    APIManager.shared.getRequestFormdata(params: parameters, file: url, httpMethod: method){ (response, success, erro) in
      if success == true {
        let json = JSON(response as Any)
        guard let message = json["message"].rawString() else {return}
        guard let err = json["code"].int else {return}
        if let status = json["status"].bool {
          if status == true {
            callback(json, nil)
          }else{
            if err == 400005 {
              if let app = UIApplication.shared.delegate as? AppDelegate {
                //                                app.showLoginScreen()
              }
              let window = UIApplication.shared.keyWindow!
              window.rootViewController?.view.makeToast(message: "Session Expired! Please login again to continue.")
            }else{
              let error = NSError(domain: "\(err)",
                code: err,
                userInfo: [NSLocalizedDescriptionKey: message])
              callback(message,error)
            }
          }
        }
      }else {
        callback(nil,erro)
      }
    }
  }
  
  func sendGetRequest(url: String, callback: @escaping (_ data: Any?, _ err: Error?)-> ()){
    APIManager.shared.getRequest(file: url, httpMethod: .GET) { (response, success, err) in
      print("the get url value is",url)
      if success == true {
        let json = JSON(response as Any)
        guard let message = json["message"].rawString() else {return}
        guard let err = json["code"].int else {return}
        if let status = json["status"].bool {
          if status == true {
            callback(json, nil)
          }else{
            if err == 400005 {
              if let app = UIApplication.shared.delegate as? AppDelegate {
                //                                app.showLoginScreen()
              }
              let window = UIApplication.shared.keyWindow!
              window.rootViewController?.view.makeToast(message: "Session Expired! Please login again to continue.")
            }else {
              let error = NSError(domain: "\(err)",
                code: err,
                userInfo: [NSLocalizedDescriptionKey: message])
              callback(message,error)
            }
          }
        }
      }else {
        callback(nil,err)
      }
    }
  }
  
  func sendImageRequest(parameters:[String : String], images: [String : UIImage]?, url: String, method: VKMethodType, callback: @escaping (_ data: Any?, _ err: Error?)-> ()){
    APIManager.shared.getRequestFormdata(params: parameters, images: images, file: url, httpMethod: method) { (response, success, erro) in
      if success == true {
        let json = JSON(response as Any)
        guard let message = json["message"].rawString() else {return}
        guard let err = json["code"].int else {return}
        if let status = json["status"].bool {
          if status == true {
            callback(json, nil)
          }else{
            if err == 400005 {
              if let app = UIApplication.shared.delegate as? AppDelegate {
                //                                app.showLoginScreen()
              }
              let window = UIApplication.shared.keyWindow!
              window.rootViewController?.view.makeToast(message: "Session Expired! Please login again to continue.")
            }else{
              let error = NSError(domain: "\(err)",
                code: err,
                userInfo: [NSLocalizedDescriptionKey: message])
              callback(message,error)
            }
          }
        }
      }else {
        callback(nil,erro)
      }
    }
  }
  
  func getProfileInfo(callback: @escaping (_ data: Any?, _ err: Error?)-> ()){
    sendGetRequest(url: Constants.GET_PROFILE_INFO) { (data, err) in
      callback(data,err)
    }
  }
  
  

}


    
    




