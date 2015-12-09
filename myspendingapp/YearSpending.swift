//
//  YearSpending.swift
//  myspendingapp
//
//  Created by GaryLai on 7/12/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import ObjectMapper

class YearSpending : ModelBase {
    var total: Float?;
    var spendingTypeId: Int?;
    
    override init() {
        super.init();
    }
    
    required init?(_ map: Map) {
        super.init(map);
    }
    
    override func doMap(map: Map) {
        super.doMap(map);
        
        total <- map["total"];
        spendingTypeId <- map["spending_type_id"];
    }
    
    override func validateMapping() -> Bool {
        return super.validateMapping() &&
            total != nil &&
            spendingTypeId != nil;
    }

}