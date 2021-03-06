//
//  Spending.swift
//  myspendingapp
//
//  Created by GaryLai on 14/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation
import ObjectMapper

class Spending : ModelBase {
    static let NOTE_MAX_LENGTH: Int = 100;
    
    var id : String?;
    var userId: String?;
    var spendingTypeId : Int?;
    var value : Float?;
    var date : NSDate?;
    var note : String?;
    
    override init() {
        super.init();
    }
    
    required init?(_ map: Map) {
        super.init(map);
    }
    
    override func doMap(map: Map) {
        super.doMap(map);
        
        id <- map["id"];
        userId <- map["user_id"];
        spendingTypeId <- map["spending_type_id"];
        value <- map["value"];
        date <- (map["date_of_spending"], CustomDateFormatTransform(formatString: "dd-MM-yyyy"));
    }
    
    override func validateMapping() -> Bool {
        return super.validateMapping() &&
                    id != nil &&
                    userId != nil &&
                    spendingTypeId != nil &&
                    value != nil &&
                    date != nil;
    }
}
