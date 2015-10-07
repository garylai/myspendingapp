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
    
    private var _isIncorrect : Bool
    var isIncorrect : Bool {
        set (newValue) {
            _isIncorrect = newValue;
            if isIncorrect {
                self.layer.borderColor = UIColor.redColor().CGColor;
            } else {
                self.layer.borderColor = self.borderColor?.CGColor ?? UIColor.clearColor().CGColor;
            }
        }
        get {
            return _isIncorrect;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        _isIncorrect = false;
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
