//
//  issueStatus.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation


enum issueStatus: String, Codable {
    case open = "open"
    case complete = "complete"
    case inProgress = "inProgress"
    case needsAnalysis = "needsAnalysis"
}
