//
//  Validator.swift
//  myspendingapp
//
//  Created by GaryLai on 7/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

public protocol Rule {
    func validate(targetField: UITextField) -> Bool;
}