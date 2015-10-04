//
//  Util.swift
//  myspendingapp
//
//  Created by Gary Lai on 4/10/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import Foundation

enum kAPIError<String> {
    case ServerReturned(String) // put the first error messages here
    case SystemReturned(ErrorType)
}