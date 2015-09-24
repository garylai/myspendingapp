//
//  MSATextField.swift
//  myspendingapp
//
//  Created by GaryLai on 24/9/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class MSATextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.layer.borderColor = UIColor.lightGrayColor().CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5.0;
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10);
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10);
    }

}
