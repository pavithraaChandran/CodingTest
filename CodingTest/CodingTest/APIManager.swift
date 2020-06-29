 //
//  APIManager.swift
//  AJDA_B2C
//
//  Created by PTBLR-1128 on 22/11/18.
//  Copyright © 2018 Provab Technosoft Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

// base class...
class APIManager: NSObject {
    
    // instance
    static let shared = APIManager()
    // assign basic url path (ex: x.x.x.x/index.php)
    var basicURL = String()
    var infomaticaURL = String()

    // assign request headers as key and values
    var headers: [String: String]?
}

extension APIManager {
    
    //
    // convert json sting to object
    static func getObject(jsonString: String) -> Any {
        
        // convert string into data...
        if let dateObj = jsonString.data(using: String.Encoding.utf8) {
            do {
                // data convert into any object...
                let finalObj = try JSONSerialization.jsonObject(with: dateObj, options: []) as Any
                return finalObj
            } catch let error as NSError {
                print("Json string to object failed : \(error.localizedDescription)")
            }
        }
        return ""
    }
    
    //
    // convert object to json sting
    static func getJSONString(object: Any) -> String {
        
        // if object is already string...
        if object is String {
            return object as! String
        }
        do {
            // convert object into data...
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: [])
            
            // getting jsonString...
            let stringObj = String(data: jsonData, encoding: .utf8)
            return stringObj!
        } catch let error as NSError {
            print("Json object to string failed : \(error.localizedDescription)")
        }
        return ""
    }
}

extension APIManager {
    
    //
    // Parameters:- request body as weburl formate
    // - file: file name after the base_url
    // - httpMethod: GET, POST, UPDATE, DELETE (Ex: VKMethodType.GET)
    // - handler: we will get -result Object, -success state, -error
    //
    //

    func getRequest(file: String,
                    httpMethod: VKMethodType,
                    handler: @escaping CompletionHandler) -> Void {
        
        var urlString:String = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        
//        if file.contains("infomatica"){
//            urlString = "\(infomaticaURL)/\(file)"
//            print("the url string value is",urlString)
//        }else{
//            urlString = "\(basicURL)/\(file)"
//        }
//
        // generating url...
      //  let urlString = "\(basicURL)/\(file)"
        var url_final: URL?
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            url_final = url
        }
        else {
            handler(nil, false, nil)
            return
        }
        
        // get request...
        let request = APIManagerClient().getRequest(url: url_final!, httpMethod: httpMethod)
        print("URL :-> \(httpMethod.rawValue) : \(urlString)")
        
        
        // calling apis...
        let task = APIManagerClient.sessionConfiguration().dataTask(with: request)
        { (data, response, error) in
            
            // final response getting...
            if error != nil {
                handler(nil, false, error as NSError?)
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    handler(result, true, error as NSError?)
                } catch {
                    handler(nil, false, error as NSError?)
                }
            }
        }
        task.resume()
    }
    
    //
    // Parameters:- request body as weburl formate
    // - params: assign like key and value
    // - file: file name after the base_url
    // - httpMethod: GET, POST, UPDATE, DELETE (Ex: VKMethodType.GET)
    // - handler: we will get -result Object, -success state, -error
    //
    //
    func getRequest(params: [String: String]?,
                    file: String,
                    httpMethod: VKMethodType,
                    handler: @escaping CompletionHandler) -> Void {
        
        // generating url...
        let urlString = "\(basicURL)/\(file)?\(APIManagerClient().getParamString(params: params))"
        var url_final: URL?
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            url_final = url
        }
        else {
            handler(nil, false, nil)
            return
        }
        
        // get request...
        let request = APIManagerClient().getRequest(url: url_final!, httpMethod: httpMethod)
        print("URL :-> \(httpMethod.rawValue) : \(urlString)")
        print("Parameters :-> \(params)")
        
        // calling apis...
        let task = APIManagerClient.sessionConfiguration().dataTask(with: request)
        { (data, response, error) in
            
//            print("Server Response :-> \(data?.toString())")
            
            // final response getting...
            if error != nil {
                handler(nil, false, error as NSError?)
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    handler(result, true, error as NSError?)
                } catch {
                    handler(nil, false, error as NSError?)
                }
            }
        }
        task.resume()
    }
    
    //
    // Parameters:- request body as RAW formate
    // - params: assign like key and value
    // - file: file name after the base_url
    // - httpMethod: GET, POST, UPDATE, DELETE (Ex: VKMethodType.UPDATE)
    // - handler: we will get -result Object, -success state, -error
    //
    //
    func getRequestRaw(params: [String: String],
                       file: String,
                       httpMethod: VKMethodType,
                       handler: @escaping CompletionHandler) -> Void {
        
        // generate rquest body...
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        print("Raw : \(params)")
        
        // get request...
        let urlString = "\(basicURL)/\(file)"
        let request = APIManagerClient().getRequestRaw(url: URL.init(string: urlString)!,
                                                       httpMethod: httpMethod,
                                                       httpBody: jsonData as Data)
        print("URL :-> \(httpMethod.rawValue) : \(urlString)")
        print("Parameters :-> \(params)")
        
        // calling apis...
        let task = APIManagerClient.sessionConfiguration().dataTask(with: request)
        { (data, response, error) in
            
//            print("Server Response :-> \(data?.toString())")
            
            // final response getting...
            if error != nil {
                handler(nil, false, error as NSError?)
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    handler(result, true, error as NSError?)
                } catch {
                    handler(nil, false, error as NSError?)
                }
            }
        }
        task.resume()
    }
    
    //
    // Parameters:- request body as x-www-form-urlencoded formate
    // - params: assign like key and value
    // - file: file name after the base_url
    // - httpMethod: GET, POST, UPDATE, DELETE (Ex: VKMethodType.POST)
    // - handler: we will get -result Object, -success state, -error
    //
    //
    func getRequestXwwwform(params: [String: String],
                            file: String,
                            httpMethod: VKMethodType,
                            handler: @escaping CompletionHandler) -> Void {
        
        // generate rquest body...
        let requestString = APIManagerClient().getParamString(params: params)
        let postData = requestString.data(using: .utf8, allowLossyConversion: false)!
        print("X-www-form : \(requestString)")
        
        // get request...
        let urlString = "\(basicURL)/\(file)"
        let request = APIManagerClient().getRequestXwwwform(url: URL.init(string: urlString)!,
                                                            httpMethod: httpMethod,
                                                            httpBody: postData as Data)
        print("URL :-> \(httpMethod.rawValue) : \(urlString)")
        print("Parameters :-> \(params)")
        
        // calling apis...
        let task = APIManagerClient.sessionConfiguration().dataTask(with: request)
        { (data, response, error) in
            
//            print("Server Response :-> \(data?.toString())")
            
            // final response getting...
            if error != nil {
                handler(nil, false, error as NSError?)
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    handler(result, true, error as NSError?)
                } catch {
                    handler(nil, false, error as NSError?)
                }
            }
        }
        task.resume()
    }
}

extension APIManager {
    
    //
    // Parameters:- request body as form-data formate
    // - params: assign like key and value
    // - file: file name after the base_url
    // - httpMethod: GET, POST, UPDATE, DELETE (Ex: VKMethodType.POST)
    // - handler: we will get -result Object, -success state, -error
    //
    //
    func getRequestFormdata(params: [String: String]?,
                            file: String,
                            httpMethod: VKMethodType,
                            handler: @escaping CompletionHandler) -> Void {
        
        // get request...
        let urlString = "\(basicURL)/\(file)"
        let request = APIManagerClient().getRequestFormdata(url: URL.init(string: urlString)!,
                                                            httpMethod: httpMethod,
                                                            httpBody: getDatafrom(params: params))
        print("URL :-> \(httpMethod.rawValue) : \(urlString)")
        print("Parameters :-> \(params)")
        
        // calling apis...
        let task = APIManagerClient.sessionConfiguration().dataTask(with: request)
        { (data, response, error) in
            
//            print("Server Response :-> \(data?.toString())")
            
            // final response getting...
            if error != nil {
                handler(nil, false, error as NSError?)
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    handler(result, true, error as NSError?)
                } catch {
                    handler(nil, false, error as NSError?)
                }
            }
        }
        task.resume()
    }
    
    //
    // Parameters:- request body as form-data formate
    // - params: assign like key and value
    // - images: assign like key and value(UIImage) formate
    // - file: file name after the base_url
    // - httpMethod: GET, POST, UPDATE, DELETE (Ex: VKMethodType.POST)
    // - handler: we will get -result Object, -success state, -error
    //
    //
    func getRequestFormdata(params: [String: String]?,
                            images: [String: UIImage]?,
                            file: String,
                            httpMethod: VKMethodType,
                            handler: @escaping CompletionHandler) -> Void {
        
        // body creation...
        var body = Data()
        body.append(getDatafrom(params: params))
        body.append(getDatafrom(imgParams: images))
        
        // get request...
        let urlString = "\(basicURL)/\(file)"
        let request = APIManagerClient().getRequestFormdata(url: URL.init(string: urlString)!,
                                                            httpMethod: httpMethod,
                                                            httpBody: body)
        print("URL :-> \(httpMethod.rawValue) : \(urlString)")
        print("Parameters :-> \(params)")
        
        
        // calling apis...
        let task = APIManagerClient.sessionConfiguration().dataTask(with: request)
        { (data, response, error) in
            
//            print("Server Response :-> \(data?.toString())")
            
            // final response getting...
            if error != nil {
                handler(nil, false, error as NSError?)
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    handler(result, true, error as NSError?)
                } catch {
                    handler(nil, false, error as NSError?)
                }
            }
        }
        task.resume()
    }
    
    //
    // Parameters:- request body as form-data formate
    // - params: assign like key and value formate
    // - images_array: assign like key and value(Array with contains list of images) formate
    // - file: file name after the base_url
    // - httpMethod: GET, POST, UPDATE, DELETE (Ex: VKMethodType.POST)
    // - handler: we will get result Object, success state, error
    //
    //
    func getRequestFormdata(params: [String: String]?,
                            images_array: [String: [UIImage]]?,
                            file: String,
                            httpMethod: VKMethodType,
                            handler: @escaping CompletionHandler) -> Void {
        
        // body creation...
        var body = Data()
        body.append(getDatafrom(params: params))
        body.append(getDatafrom(imgParams: images_array))
        
        // get request...
        let urlString = "\(basicURL)/\(file)"
        let request = APIManagerClient().getRequestFormdata(url: URL.init(string: urlString)!,
                                                            httpMethod: httpMethod,
                                                            httpBody: body)
        print("URL :-> \(httpMethod.rawValue) : \(urlString)")
        print("Parameters :-> \(params)")
        
        // calling apis...
        let task = APIManagerClient.sessionConfiguration().dataTask(with: request)
        { (data, response, error) in
            
//            print("Server Response :-> \(data?.toString())")
            
            // final response getting...
            if error != nil {
                handler(nil, false, error as NSError?)
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    handler(result, true, error as NSError?)
                } catch {
                    handler(nil, false, error as NSError?)
                }
            }
        }
        task.resume()
    }
    
    func getRequestFormdata(images_array: [String: [UIImage]]?,
                            params: [String: String]?,
                            file: String,
                            httpMethod: VKMethodType,
                            handler: @escaping CompletionHandler) -> Void {
        
        // body creation...
        var body = Data()
        body.append(getDatafrom(imgParams_next: images_array))
        body.append(getDatafrom(params_next: params))
        
        // get request...
        let urlString = "\(basicURL)/\(file)"
        let request = APIManagerClient().getRequestFormdata(url: URL.init(string: urlString)!,
                                                            httpMethod: httpMethod,
                                                            httpBody: body)
        print("URL :-> \(httpMethod.rawValue) : \(urlString)")
        print("Parameters :-> \(params)")
        
        // calling apis...
        let task = APIManagerClient.sessionConfiguration().dataTask(with: request)
        { (data, response, error) in
            
//            print("Server Response :-> \(data?.toString())")
            
            // final response getting...
            if error != nil {
                handler(nil, false, error as NSError?)
            } else {
                do {
                    //                    print(data?.toString())
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    handler(result, true, error as NSError?)
                } catch {
                    handler(nil, false, error as NSError?)
                }
            }
        }
        task.resume()
    }
}

extension APIManager {
    
    func getDatafrom(params: [String: String]?) -> Data {
        
        // boundary...
        let boundary = "---------------------------14737809831466499882746641449"
        var body = Data()
        
        // params...
        if params != nil {
            for (key, value) in params! {
                
                // form data creations...
                body.append(string: "--\(boundary)\r\n")
                body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append(string: "\(value)\r\n")
                print("\(key) : \(value)")
            }
        }
        body.append(string: "--\(boundary)\r\n")
        return body
    }
    
    func getDatafrom(imgParams: [String: UIImage]?) -> Data {
        
        // boundary...
        let boundary = "---------------------------14737809831466499882746641449"
        var body = Data()
        
        // params...
        let mimetype = "image/jpg"
        if imgParams != nil {
            for (key, value) in imgParams! {
                
                // form data creations...
//                let imageData = value.UIImageJPEGRepresentation(compressionQuality: 0.7) //UIImageJPEGRepresentation(value, 0.7)
//                body.append(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"image\(key).jpg\"\r\n")
//                body.append(string: "Content-Type: \(mimetype)\r\n\r\n")
//                body.append(imageData!)
//                body.append(string: "\r\n")
//                body.append(string: "--\(boundary)--\r\n")
                
                print("\(key) : Image")
            }
        }
        return body
    }
    
    func getDatafrom(imgParams: [String: [UIImage]]?) -> Data {
        
        // boundary...
        let boundary = "---------------------------14737809831466499882746641449"
        var body = Data()
        
        // params...
        if imgParams != nil {
            for (key, valueArray) in imgParams! {
                for i in 0 ..< valueArray.count {
                    
                    let mimetype = "image\(i)/jpg"
                    
                    // form data creations...
//                    let finalKey = "\(key)[\(i)]"
//                    let imageData = valueArray[i].UIImageJPEGRepresentation(compressionQuality: 0.7) //UIImageJPEGRepresentation(valueArray[i], 0.7)
//                    body.append(string: "Content-Disposition: form-data; name=\"\(finalKey)\"; filename=\"image\(i).jpg\"\r\n")
//                    body.append(string: "Content-Type: \(mimetype)\r\n\r\n")
//                    body.append(imageData!)
//                    body.append(string: "\r\n")
//                    body.append(string: "--\(boundary)--\r\n")
                    
//                    print("\(finalKey) : Image")
                }
            }
        }
        return body
    }
    
    func getDatafrom(imgParams_next: [String: [UIImage]]?) -> Data {
        
        // boundary...
        let boundary = "---------------------------14737809831466499882746641449"
        var body = Data()
        body.append(string: "--\(boundary)--\r\n")
        
        // params...
        let mimetype = "image/jpg"
        if imgParams_next != nil {
            for (key, valueArray) in imgParams_next! {
                for i in 0 ..< valueArray.count {
                    
                    // form data creations...
//                    let finalKey = "\(key)[\(i)]"
//                    let imageData = valueArray[i].UIImageJPEGRepresentation(compressionQuality: 0.7) //UIImageJPEGRepresentation(valueArray[i], 0.7)
//                    body.append(string: "Content-Disposition: form-data; name=\"\(finalKey)\"; filename=\"image.jpg\"\r\n")
//                    body.append(string: "Content-Type: \(mimetype)\r\n\r\n")
//                    body.append(imageData!)
//                    body.append(string: "\r\n")
//                    body.append(string: "--\(boundary)--\r\n")
                    
//                    print("\(finalKey) : Image")
                }
            }
        }
        return body
    }
    
    func getDatafrom(params_next: [String: String]?) -> Data {
        
        // boundary...
        let boundary = "---------------------------14737809831466499882746641449"
        var body = Data()
        
        // params...
        if params_next != nil {
            for (key, value) in params_next! {
                
                // form data creations...
                body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append(string: "\(value)\r\n")
                body.append(string: "--\(boundary)\r\n")
                print("\(key) : \(value)")
            }
        }
        return body
    }
}

// appending string...
extension Data {
    mutating func append(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}


// typealias declaration...
typealias CompletionHandler = (_ resultObject: Any?, _ success: Bool, _ error: Error?) -> Void
typealias VKMethodType = APIManagerClient.HttpMethods
class APIManagerClient: NSObject {
    
    // httpMethod types...
    enum HttpMethods: String {
        case POST = "POST"
        case GET = "GET"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    static func sessionConfiguration() -> URLSession {
        
        // configuration session...
        let defaultConfigur = URLSessionConfiguration.default
        let defaultSession = URLSession.init(configuration: defaultConfigur,
                                             delegate: nil,
                                             delegateQueue: OperationQueue.main)
        return defaultSession
    }
    
    func getParamString(params: [String: String]?) -> String {
        
        // getting params string...
        var requestString = ""
        if params != nil {
            for (key, value) in params! {
                if requestString.count == 0 {
                    requestString = "\(key)=\(value)"
                } else {
                    requestString = "\(requestString)&\(key)=\(value)"
                }
            }
        }
        return requestString
    }
    
    func getHeaders(requests: URLRequest) -> URLRequest {
        
        // adding headers...
        var request = requests as URLRequest
        if APIManager.shared.headers != nil {
            for (key, value) in APIManager.shared.headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    func getRequest(url: URL, httpMethod: VKMethodType) -> URLRequest {
        
        // generate request...
        var request = URLRequest.init(url: url)
        request.httpMethod = httpMethod.rawValue
        return getHeaders(requests: request)
    }
    
    func getRequestRaw(url: URL, httpMethod: VKMethodType, httpBody: Data) -> URLRequest {
        
        // generate request...
        var request = URLRequest.init(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",
                         forHTTPHeaderField: "Accept")
        return getHeaders(requests: request)
    }
    
    func getRequestXwwwform(url: URL, httpMethod: VKMethodType, httpBody: Data) -> URLRequest {
        
        // generate request...
        var request = URLRequest.init(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        request.addValue(String(describing: httpBody.count),
                         forHTTPHeaderField: "Content-Length")
        request.addValue("application/x-www-form-urlencoded charset=utf-8",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded charset=utf-8",
                         forHTTPHeaderField: "Accept")
        return getHeaders(requests: request)
    }
    
    func getRequestFormdata(url: URL, httpMethod: VKMethodType, httpBody: Data) -> URLRequest {
        
        // generate request...
        let boundary = "---------------------------14737809831466499882746641449"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        
        // generate request...
        var request = URLRequest.init(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        return getHeaders(requests: request)
    }
}
