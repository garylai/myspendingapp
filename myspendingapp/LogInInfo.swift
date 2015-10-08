//
//  LogInInfo.swift
//  myspendingapp
//
//  Created by GaryLai on 8/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation

class LogInInfo : NSObject, NSCoding{
    let id : String?;
    let token : String?;
    
    init(id: String, token: String) {
        self.id = id;
        self.token = token;
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id");
        aCoder.encodeObject(token, forKey: "token");
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObjectForKey("id") as? String;
        token = aDecoder.decodeObjectForKey("token") as? String;
    }
}