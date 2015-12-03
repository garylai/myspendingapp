//
//  Util.swift
//  myspendingapp
//
//  Created by Gary Lai on 4/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

enum APIError {
    case ServerReturned(AnyObject?)
    case SystemReturned(ErrorType?)
}

protocol RequestMaker {
    func makeRequest(
    method: String,
    _ relativePath: String,
    parameters: [String: AnyObject]?,
    customHeaders: [String: String]?,
    successCallback: ((AnyObject?) -> Void)?,
    failedCallback: ((APIError?, String?) -> Void)?,
    completedCallback: (() -> Void)?);
}

protocol LogInInfoManager {
    func setLoginInfo(obj : LogInInfo) -> Bool;
    func getLoginInfo() -> LogInInfo?;
    func deleteLoginInfo() -> Bool;
}

class Util : RequestMaker, LogInInfoManager{
    private static var _instance : Util!;
    private static let KEY_CHAIN_KEY = "log-in-info"
    var spendingTypesDict : [Int : SpendingType]!;
    
    static var instance : Util{
        get {
            if _instance == nil {
                _instance = Util();
            }
            return _instance;
        }
    }
    
    var spendingTypes : [SpendingType]! {
        didSet {
            spendingTypesDict = [Int : SpendingType]();
            for spt in spendingTypes {
                spendingTypesDict[spt.id!] = spt;
            }
        }
    }
    
    var nsURLSession : NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: NSOperationQueue.mainQueue());
        return session;
    }();
    
    
    func setLoginInfo(obj : LogInInfo) -> Bool{
        return KeychainWrapper.setObject(obj, forKey: Util.KEY_CHAIN_KEY);
    }
    
    func getLoginInfo() -> LogInInfo? {
        return KeychainWrapper.objectForKey(Util.KEY_CHAIN_KEY) as? LogInInfo;
    }
    
    func deleteLoginInfo() -> Bool {
        return KeychainWrapper.removeObjectForKey(Util.KEY_CHAIN_KEY);
    }
    
    func makeRequest(
        method: String,
        _ relativePath: String,
        parameters: [String: AnyObject]? = nil,
        customHeaders: [String: String]? = nil,
        successCallback: ((AnyObject?) -> Void)? = nil,
        failedCallback: ((APIError?, String?) -> Void)? = nil,
        completedCallback: (() -> Void)? = nil) {
            let url = NSURL.init(scheme: "https", host: ENV.APIDomain, path: "/api/\(ENV.APIVersion)/\(relativePath)");
            let urlRequest = NSMutableURLRequest.init(URL: url!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15);
            urlRequest.HTTPMethod = method;
            var headers = ["Content-Type": "application/json"];
            headers.merge(customHeaders);
            urlRequest.allHTTPHeaderFields = headers;
            if parameters != nil{
                do {
                    urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters!, options: []);
                } catch let error {
                    failedCallback?(APIError.SystemReturned(error), nil);
                    return;
                }
            }
            let task = nsURLSession.dataTaskWithRequest(urlRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if data != nil {
                   print(NSString(data: data!, encoding: NSUTF8StringEncoding));
                }
                print(response);
                print(error);
                guard error == nil else {
                    failedCallback?(APIError.SystemReturned(error), nil);
                    completedCallback?();
                    return;
                }
                
                assert(response != nil);
                assert(response!.isKindOfClass(NSHTTPURLResponse));
         
                let httpResponse = response as! NSHTTPURLResponse;
                var responseJson : AnyObject? = nil;
                do {
                    responseJson = try NSJSONSerialization.JSONObjectWithData(data!, options: []);
                } catch let error {
                    failedCallback?(APIError.SystemReturned(error), nil);
                    completedCallback?();
                    return;
                }
                if (200..<300).contains(httpResponse.statusCode) {
                    successCallback?(responseJson);
                } else {
                    failedCallback?(APIError.ServerReturned(responseJson), nil);
                }
                completedCallback?();
            }
        task.resume();
    }
    
    var mainController: MainViewController {
        get {
            let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate;
            return appDelegate.window!.rootViewController as! MainViewController;
        }
    }
    
    func loadSpendingType() -> Bool {
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
    mutating func merge(dict: [Key: Value]?){
        guard dict != nil else {
            return;
        }
        for (k, v) in dict! {
            self.updateValue(v, forKey: k);
        }
    }
}








