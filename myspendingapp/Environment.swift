//
//  Environment.swift
//  myspendingapp
//
//  Created by Gary Lai on 4/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation

struct ENV {
    enum kEnvironment {
        case development
        case production
    }
    
    static let Environment = kEnvironment.development;
    
    static var APIDomain : String! {
        if Environment == .development {
            return "myspendingapp-dev.herokuapp.com";
        } else if Environment == .production {
            return "myspendingapp.herokuapp.com";
        } else {
            return nil;
        }
    }
    
    static var APIVersion : String! {
        if Environment == .development {
            return "v1";
        } else if Environment == .production {
            return "v1";
        } else {
            return nil;
        }
    }
    
    static var APIURLPrefix : String! {
        return "https://\(APIDomain)/api/\(APIVersion)";
    }
}
