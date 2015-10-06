//
//  Util.swift
//  myspendingapp
//
//  Created by Gary Lai on 4/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import Alamofire

enum kAPIError {
    case ServerReturned(AnyObject?)
    case SystemReturned(ErrorType?)
}

extension Manager {
    func requestWithCallbacks (
        method: Alamofire.Method,
        _ URLString: Alamofire.URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: Alamofire.ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        surpassAlert: Bool = false,
        successCallback: ((AnyObject?) -> Void)? = nil,
        failedCallback: ((kAPIError) -> Void)? = nil,
        completedCallback: (() -> Void)? = nil)
        -> Alamofire.Request
    {
        return self.request(method, URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers)
            .responseJSON { _, response, result in
                var message : String?
                var error : kAPIError?
                if let statusCode = response?.statusCode where (200..<300).contains(statusCode){
                        print("succeed with : \(result.value)");
                        successCallback?(result.value);
                } else if let _ = response?.statusCode {
                        print("failed with : \(result.value)");
                        message = (result.value as? [String: [String]])?["errors"]?[0];
                        error = kAPIError.ServerReturned(result.value);
                } else {
                    print("failed with: \(result.error)");
                    message = {
                            if let err = result.error as? NSURLError where err == .NotConnectedToInternet {
                                return "Cannot connect to the internet";
                            }
                            return nil;
                        }();
                    error = kAPIError.SystemReturned(result.error);
                }
                if error != nil {
                    let alert = UIAlertView(title: "Login Failed", message: message, delegate: nil, cancelButtonTitle: "OK");
                    alert.show();
                    failedCallback?(error!)
                }
                print("completed");
                completedCallback?();
        }
    }
}
class Util {
    static let alamofireManager : Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 20 // seconds
        configuration.timeoutIntervalForResource = 20
        return Alamofire.Manager(configuration: configuration)}();
    
    static var mainController: MainViewController {
        get {
            let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate;
            return appDelegate.window!.rootViewController as! MainViewController;
        }
    }
//    
//    static func request(
//        method: Alamofire.Method,
//        _ URLString: Alamofire.URLStringConvertible,
//        parameters: [String: AnyObject]? = nil,
//        encoding: Alamofire.ParameterEncoding = .URL,
//        headers: [String: String]? = nil,
//        successCallback: ((AnyObject?) -> Void)? = nil,
//        failedCallback: ((kAPIError) -> Void)? = nil,
//        completedCallback: (() -> Void)? = nil)
//        -> Alamofire.Request
//     {
//        return _manager.requestWithCallbacks(method, URLString,
//                                            parameters: parameters,
//                                            encoding: encoding,
//                                            headers: headers,
//                                            successCallback: successCallback,
//                                            failedCallback: failedCallback,
//                                            completedCallback: completedCallback);
//    }
}







