//
//  IssueTypeIcon.swift
//  BugTracker
//
//  Created by Elijah on 3/7/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI

struct IssueTypeIcon: View {
    
    @Binding var type: issueType
    
    var body: some View {
        Text("\(self.firstLetter(type: self.type))")
            .foregroundColor(self.type.colorForType(type: type))
            .font(Font.system(.title, design: .rounded))
    }
    
    func firstLetter(type: issueType) -> String {
        
        let rawValue = type.rawValue
        let firstLetter = String(rawValue.first!)
        
        return firstLetter
    }
    
}

//struct IssueTypeIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var type = issueType.init(rawValue: "bug")
//        IssueTypeIcon(type: $type)
//    }
//}
