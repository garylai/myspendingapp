//
//  MSATextField.swift
//  myspendingapp
//
//  Created by GaryLai on 24/9/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class MSATextField: UITextField {
    private var _boarderColor : UIColor?
    @IBInspectable var borderColor : UIColor? {
        set (newValue) {
            _boarderColor = newValue;
            self.layer.borderColor = (newValue ?? UIColor.clearColor()).CGColor;
        }
        get {
            return _boarderColor;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.borderStyle = .None;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5.0;
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0);
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0);
    }

}
