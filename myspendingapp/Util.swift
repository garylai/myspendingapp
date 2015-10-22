//
//  Util.swift
//  myspendingapp
//
//  Created by Gary Lai on 4/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import ObjectMapper

enum APIError {
    case ServerReturned(AnyObject?)
    case SystemReturned(ErrorType?)
}

// Dummy class to make the error as NSError works in AppDelegate
// Compiler magic not working without this class
private class Dummy {
    private func foo() throws { }
    private func bar () {
        do {
            try foo()
        } catch ( _ as NSError){ }
    }
}

extension Manager {
    func requestWithCallbacks (
        method: Alamofire.Method,
        _ relativePath: String,
        parameters: [String: AnyObject]? = nil,
        encoding: Alamofire.ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        successCallback: ((AnyObject?) -> Void)? = nil,
        failedCallback: ((APIError?, String?) -> Void)? = nil,
        completedCallback: (() -> Void)? = nil)
        -> Alamofire.Request
    {
        return self.request(method, "\(ENV.APIURLPrefix)/\(relativePath)",
            parameters: parameters,
            encoding: encoding,
            headers: headers)
            .responseJSON { response in
                var message : String?
                var error : APIError?
                if let _ = response.result.error {
                    print("failed with: \(response.result.error)");
                    message = {
                        if let err = response.result.error as? NSURLError where err == .NotConnectedToInternet {
                            return "Cannot connect to the internet";
                        }
                        return nil;
                        }();
                    error = APIError.SystemReturned(response.result.error);
                } else if let statusCode = response.response?.statusCode {
                    if (200..<300).contains(statusCode) {
                        print("succeed with : \(response.result.value)");
                        successCallback?(response.result.value);
                    } else {
                        print(statusCode);
                        print("failed with : \(response.result.value)");
                        message = (response.result.value as? [String: [String]])?["errors"]?[0];
                        error = APIError.ServerReturned(response.result.value);
                    }
                } else {
                    failedCallback?(nil, nil);
                }
                
                if error != nil {
                    failedCallback?(error!, message);
                }
                print("completed");
                completedCallback?();
        }
    }
}

class Util {
    private static let KEY_CHAIN_KEY = "log-in-info"
    
    static var spendingTypes : [SpendingType]! {
        didSet {
            spendingTypesDict = [Int : SpendingType]();
            for spt in spendingTypes {
                spendingTypesDict[spt.id!] = spt;
            }
        }
    }
    
    static var spendingTypesDict : [Int : SpendingType]!;
    
    static func setLoginInfo(obj : LogInInfo) -> Bool{
        return KeychainWrapper.setObject(obj, forKey: KEY_CHAIN_KEY);
    }
    
    static func getLoginInfo() -> LogInInfo? {
        return KeychainWrapper.objectForKey(KEY_CHAIN_KEY) as? LogInInfo;
    }
    
    static func deleteLoginInfo() -> Bool {
        return KeychainWrapper.removeObjectForKey(KEY_CHAIN_KEY);
    }
    
    static let alamofireManager : Manager = { 
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        configuration.timeoutIntervalForRequest = 20 // seconds
//        configuration.timeoutIntervalForResource = 20
        return Alamofire.Manager(configuration: configuration)}();
    
    static var mainController: MainViewController {
        get {
            let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate;
            return appDelegate.window!.rootViewController as! MainViewController;
        }
    }
    
    static func loadSpendingType() -> Bool {
        guard let path = NSBundle.mainBundle().pathForResource("spending_types", ofType: "json") else {
            return false;
        }
        let jsonString = try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        if let sts = Mapper<SpendingType>().mapArray(jsonString as String?) {
            spendingTypes = sts;
        } else {
            return false;
        }
        return true;
    }
}


extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            self.updateValue(v, forKey: k);
        }
    }
}








