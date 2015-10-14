//
//  SpendingType.swift
//  myspendingapp
//
//  Created by GaryLai on 14/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import ObjectMapper

class SpendingType : ModelBase {
    var id : String?;
    var name : String?;
    
    required init?(_ map: Map) {
        super.init(map);
    }
    
    override func doMap(map: Map) {
        super.doMap(map);
        
        id <- map["id"];
        name <- map["name"];
    }
    
    override func validateMapping() -> Bool {
        return super.validateMapping() && id != nil && name != nil;
    }
}