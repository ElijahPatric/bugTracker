//
//  IssueType.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import Foundation


enum issueType: String, CaseIterable, Codable {
    case none = "none"
    case bug = "bug"
    case feature = "feature"
    case question = "question"
    case support = "support"
    
    static let allValues: [String] = [none.rawValue,
                                      bug.rawValue,
                                      feature.rawValue,
                                      question.rawValue,
                                      support.rawValue]
    
    static let dictionaryValues: [String:issueType] = [none.rawValue: .none,
                                                       bug.rawValue:.bug,
                                                       feature.rawValue:.feature,
                                                       question.rawValue:.question,
                                                       support.rawValue:.support]
    
}
