//
//  EmailRule.swift
//  myspendingapp
//
//  Created by GaryLai on 7/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class EmailRule : Rule {
    static let REGEX_STR = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
    private let _regex : NSRegularExpression;
    init () {
        _regex = try! NSRegularExpression(pattern: EmailRule.REGEX_STR, options: []);
    }
    func validate(targetField: UITextField) -> Bool {
        if let text = targetField.text {
            let matches = _regex.matchesInString(text,
                                                options: [],
                                                range: NSRange(location: 0, length: text.characters.count));
            return matches.count == 1;
        } else {
            return false;
        }
    }
}
