//
//  MonthSpending.swift
//  myspendingapp
//
//  Created by GaryLai on 7/12/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import ObjectMapper

class MonthSpending : ModelBase {
    var total: Float?;
    var monthOfSpending: Int?;
    
    override init() {
        super.init();
    }
    
    required init?(_ map: Map) {
        super.init(map);
    }
    
    override func doMap(map: Map) {
        super.doMap(map);
        
        total <- map["total"];
        monthOfSpending <- map["month_of_spending"];
    }
    
    override func validateMapping() -> Bool {
        return super.validateMapping() &&
            total != nil &&
            monthOfSpending != nil;
    }
    
}
