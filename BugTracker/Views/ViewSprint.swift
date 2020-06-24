//
//  ViewSprint.swift
//  BugTracker
//
//  Created by Elijah on 5/18/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
struct ViewSprint: View {
    
    @Binding var selectedSprint: sprint?
    @ObservedObject var helper = IssueHelper(withListner: true)
    
    var body: some View {
        //display title of sprint, otherwise display start/end date
        VStack {
            Text("\(helper.issuesForSprint.first?.title ?? "(Sprint Does Not Have Title)")")
                .font(Font.system(.headline, design: .rounded))

            List(helper.issuesForSprint(sprint:self.selectedSprint!)) {
                listIssue in
                VStack {
                    Text("issue title: \(listIssue.title ?? "no title")")
                    Text("issue id: \(listIssue.issueID)")
                }
            }
        }
    }
}

struct ViewSprint_Previews: PreviewProvider {
    
    @State static var mySprint: sprint? = sprint(
        sprintID: 22,
        duration: 7,
        startTimestamp: Timestamp(date: Date()),
        endTimestamp: Timestamp(date: Date()),
        title: "Push for New Feature",
        description: "focus here will be new features",
        points: 33)
    
    static var previews: some View {
        ViewSprint(selectedSprint: $mySprint)
    }
}
