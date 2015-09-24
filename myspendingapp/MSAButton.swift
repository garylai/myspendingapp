//
//  MSAButton.swift
//  myspendingapp
//
//  Created by GaryLai on 24/9/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class MSAButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.layer.borderColor = UIColor.redColor().CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5.0;
    }

}
