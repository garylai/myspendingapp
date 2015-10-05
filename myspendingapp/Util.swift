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
    case ServerReturned(String?) // put the first error messages here
    case SystemReturned(ErrorType?)
}

class Util {
     static func doRequest(
        method: Alamofire.Method,
        _ URLString: Alamofire.URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: Alamofire.ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        successCallback: ((AnyObject?) -> Void)? = nil,
        failedCallback: ((kAPIError) -> Void)? = nil,
        completedCallback: (() -> Void)? = nil)
        -> Alamofire.Request
     {
        return Alamofire.request(method, URLString,
                                    parameters: parameters,
                                    encoding: encoding,
                                    headers: headers)
                    .responseJSON { _, response, result in
                        if let statusCode = response?.statusCode {
                            if (200..<300).contains(statusCode) {
                                print("succeed with : \(result.value)");
                                successCallback?(result.value);
                            } else {
                                // pop message
                                print("failed with : \(result.value)");
                                if failedCallback != nil {
                                    let message = (result.value as? [String: [String]])?["errors"]?[0]
                                    failedCallback!(kAPIError.ServerReturned(message))
                                };
                            }
                        } else {
                            // pop message
                            print("failed with: \(result.error)");
                            failedCallback?(kAPIError.SystemReturned(result.error));
                        }
                        print("completed");
                        completedCallback?();
                }
    }
}