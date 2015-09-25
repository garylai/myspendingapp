//
//  MSAButton.swift
//  myspendingapp
//
//  Created by GaryLai on 24/9/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class MSAButton: UIButton {
    
    private var _highlightedAlpha : NSNumber?
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
    
    @IBInspectable var highlightedAlpha : NSNumber? {
        set (newValue) {
            _highlightedAlpha = newValue;
        }
        get {
            return _highlightedAlpha;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5.0;
        
        self.addTarget(self, action: "highlightBorder", forControlEvents: UIControlEvents.TouchDown);
        self.addTarget(self, action: "unhighlightBorder", forControlEvents: UIControlEvents.TouchUpOutside);
        self.addTarget(self, action: "unhighlightBorder", forControlEvents: UIControlEvents.TouchUpInside);
        
    }
    
    func highlightBorder() {
        if let alpha = _highlightedAlpha?.floatValue {
            if let color = _boarderColor?.colorWithAlphaComponent(CGFloat(alpha)) {
                self.layer.borderColor = color.CGColor;
            }
        }
    }
    
    func unhighlightBorder() {
        if let color = _boarderColor?.colorWithAlphaComponent(1) {
            self.layer.borderColor = color.CGColor;
        }
    }
}
