//
//  PermissionLevels.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation


enum permissionLevel: String, Codable {
    case everyone = "everyone"
    case support = "support"
    case developer = "developer"
    case admin = "admin"
    
}
