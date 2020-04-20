//
//  SprintStatus.swift
//  BugTracker
//
//  Created by Elijah on 4/20/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation

enum sprintStatus: String, Codable {
    case current = "current"
    case complete = "complete"
    case future = "future"
}
