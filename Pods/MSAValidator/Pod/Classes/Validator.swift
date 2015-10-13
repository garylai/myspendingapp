//
//  Validator.swift
//  myspendingapp
//
//  Created by GaryLai on 7/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

struct ValidationEntry {
    var rules : [Rule];
    var name : String;
}

public class Validator {
    private var _fieldsAndRules : [UITextField : ValidationEntry];
    
    public init () {
        _fieldsAndRules = [UITextField : ValidationEntry]();
    }
    
    public func register(targetField : UITextField, withName fieldName: String, forRules rules : Rule...) {
        let validationEntry = ValidationEntry(rules: rules, name: fieldName);
        _fieldsAndRules[targetField] = validationEntry;
    }
    
    public func validate() -> (valid: [UITextField], invalid: [UITextField : [Rule]], params: [String : String]) {
        var invalidFields = [UITextField : [Rule]]();
        var validFields = [UITextField]();
        var params = [String : String]();
        for element in _fieldsAndRules {
            let targetTextField = element.0;
            let validationEntry = element.1;
            
            var failedRules = [Rule]();
            for rule in validationEntry.rules {
                if !rule.validate(targetTextField) {
                    failedRules.append(rule);
                }
            }
            
            if failedRules.count > 0 {
                invalidFields[targetTextField] = failedRules;
            } else {
                validFields.append(targetTextField);
                params[validationEntry.name] = targetTextField.text;
            }
            
        }
        return (valid: validFields, invalid: invalidFields, params);
    }
}
