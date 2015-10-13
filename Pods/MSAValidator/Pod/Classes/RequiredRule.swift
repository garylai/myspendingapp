//
//  RequiredRule.swift
//  myspendingapp
//
//  Created by GaryLai on 7/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

public class RequiredRule : Rule {
    public init() {
        
    }
    public func validate(targetField: UITextField) -> Bool {
        guard let text = targetField.text where !text.isEmpty else {
            return false
        }
        return true;
    }
}