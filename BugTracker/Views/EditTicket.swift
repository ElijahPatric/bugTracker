//
//  EditTicket.swift
//  BugTracker
//
//  Created by Elijah on 3/11/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct EditTicket: View {
    
    @Binding var editIssue: issue?
    @Binding var isPresented: Bool

    @State var title = ""
    @State var description = ""
    @State var selectedTypeIndex = 0
    @State var selectedTypeString = ""
    @State var selectedSprintIndex = -1
    @State var storyPointsString = ""
    @State var epic = ""
    @State var sprint = ""
    @State var isSelected = false
    @State var selectedTitle = ""
    @State private var scale: CGFloat = 1.2
    @State var counter = 0
    var storyPoints: Int {
        get {
            if let points = Int(self.storyPointsString) {
                return points
            } else {
                return 0
            }
        }
    }
    @ObservedObject var helper = IssueHelper(withListner: false)
    @ObservedObject var sprintHelper = IssueHelper(withListnerForSprints: true)
    let issueTypesArray: [String] = issueType.allValues
    
    var body: some View {
        //////////////
        VStack {
            NavigationView {
                Form {
                    Section {
                        TextField("\(self.editIssue!.title ?? "Title")", text: $title)
                            
                    }
                    Section {
                        TextField("\(self.editIssue!.description ?? "description")", text: $description)
                        .lineLimit(nil)
                    }
                    Section {
                        ScrollView(.horizontal,showsIndicators: false) {
                            HStack {
                                
                                //list of possible issue types. Existing one pre-selected
                                ForEach(0..<self.issueTypesArray.count) { counter in
                                    IssueTypeElement(titleText: self.issueTypesArray[counter]) { () -> ()? in
                                        self.counter += 1
                                        self.isSelected = true
                                        self.selectedTitle = self.issueTypesArray[counter]
                                        self.selectedTypeString =
                                            self.issueTypesArray[counter]
                                        
                                        return nil
                                    }.scaleEffect(self.isSelected && self.selectedTypeString == self.issueTypesArray[counter] ? self.scale : 1)
                                        .onAppear {
                                            if self.issueTypesArray[counter] == self.editIssue!.type.rawValue {
                                                self.selectedTypeString = self.issueTypesArray[counter]
                                                self.isSelected = true
                                            }
                                    }
                                }
                                
                            }
                        }
                    }
                    Section {
                        TextField("Story Points", text: $storyPointsString)
                            .keyboardType(.numberPad)
                    }
                    Section {
                        VStack {
                            if self.sprintHelper.sprints.count > 0 {
                                Picker(selection: $selectedSprintIndex, label: Text("Sprint")) {
                                    ForEach(0..<self.sprintHelper.sprints.count) { counter in
                                        Text("\(self.sprintHelper.sprints[counter].title ?? "no title")")
                                    }
                                
                                }
                            }
                        }
                    }
                    Section {
                        VStack {
                            Picker(selection: $epic, label: Text("Epic")) {
                                ForEach(0..<4) {_ in
                                    Text("Epic")
                                }
                            }
                        }
                    }
            
                }.navigationBarTitle("Edit Issue")
                
            }.onAppear {
                //will need to set epic and sprint when that is implemented
                self.title = self.editIssue!.title ?? "Title of Issue"
                self.storyPointsString = String(self.editIssue!.points!)
                self.description = self.editIssue!.description ?? "description"
                
            }
            
            Button(action: {
                self.saveTicket()
                self.isPresented = false
            }) {
                Text("Save Edits")
            }
            
        }
    }
    
        func saveTicket() {
            
            var newTicket = issue(title: self.title,
                                    description: self.description,
                                    issueID: self.editIssue!.id,
                                    points: self.storyPoints,
                                    assignee: nil,
                                    type: issueType(rawValue: self.selectedTypeString) ?? .none,
                                    sprintID: nil,
                                    epicID: nil,
                                    status: .open,
                                    timestamp: self.editIssue!.timestamp)
            
            if selectedSprintIndex != -1 && sprintHelper.sprints.isEmpty == false {
                newTicket.sprintID = sprintHelper.sprints[self.selectedSprintIndex].sprintID
            }
            
            sprintHelper.saveIssue(ticket: newTicket,existingIssue: true)
        }

}


struct EditTicket_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var editIssue: issue? =
        issue(title: "Preview Title",
                         description: "Preview Description",
                         issueID: 99,
                         points: 2,
                         assignee: nil,
                         type: .feature,
                         sprintID: nil,
                         epicID: nil,
                         status: .open,
                         timestamp: Timestamp(date: Date()))
                         //isPresented: $isPresented
    static var previews: some View {
        EditTicket(editIssue: $editIssue, isPresented: $isPresented)
    }
}
