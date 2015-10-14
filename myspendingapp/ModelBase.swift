//
//  ModelBase.swift
//  myspendingapp
//
//  Created by GaryLai on 14/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelBase : NSObject, Mappable {
    var mappingValid : Bool?;
    
    override init(){
        super.init();
    }
    
    required init?(_ map: Map) {
        super.init();
    }
    
    func mapping(map: Map) {
        doMap(map);
        mappingValid = validateMapping();
    }
    
    func doMap(map: Map) { }
    
    func validateMapping() -> Bool {
        return true;
    }
}
