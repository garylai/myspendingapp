//
//  LogInInfo.swift
//  myspendingapp
//
//  Created by GaryLai on 8/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import ObjectMapper

class LogInInfo : ModelBase, NSCoding {
    var id : String?;
    var token : String?;
    
    required init?(_ map: Map) {
        super.init(map);
    }
    
    init(id: String, token: String) {
        self.id = id;
        self.token = token;
        
        super.init();
    }
    
    override func doMap(map: Map) {
        super.doMap(map);
        
        id <- map["id"];
        token <- map["token"];
    }
    
    override func validateMapping() -> Bool {
        return super.validateMapping() && id != nil && token != nil;
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id");
        aCoder.encodeObject(token, forKey: "token");
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        super.init();
        id = aDecoder.decodeObjectForKey("id") as? String;
        token = aDecoder.decodeObjectForKey("token") as? String;
    }
}