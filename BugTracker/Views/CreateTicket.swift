//
//  CreateTicket.swift
//  BugTracker
//
//  Created by Elijah on 2/11/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
struct CreateTicket: View {

    @State var title = ""
    @State var description = ""
    @State var selectedTypeIndex = 0
    @State var selectedTypeString = ""
    @State var storyPointsString = ""
    @State var epic = ""
    @State var isSelected = false
    @State private var scale: CGFloat = 1.2
    @Binding var isPresented: Bool
    @State var selectedSprintIndex = -1
    var storyPoints: Int {
        get {
            if let points = Int(self.storyPointsString) {
                return points
            } else {
                return 0
            }
        }
    }
    let issueTypesArray: [String] = issueType.allValues
    @ObservedObject var helper = IssueHelper(withListnerForSprints: true)
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section {
                        TextField("Title", text: $title)
                    }
                    Section {
                        TextField("Description", text: $description)
                        .lineLimit(nil)
                    }
                    Section {
                        ScrollView(.horizontal,showsIndicators: false) {
                            HStack {
                                
                                //list of possible issue types
                                ForEach(0..<self.issueTypesArray.count) { counter in
                                    IssueTypeElement(titleText: self.issueTypesArray[counter]) { () -> ()? in
                                        self.isSelected = true
                                        self.selectedTypeString = self.issueTypesArray[counter]
                                        
                                        return nil
                                    }.scaleEffect(self.isSelected && self.selectedTypeString == self.issueTypesArray[counter] ? self.scale : 1)
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
                            if self.helper.sprints.count > 0 {
                                Picker(selection: $selectedSprintIndex, label: Text("Sprint")) {
                                    ForEach(0..<self.helper.sprints.count) { counter in
                                        Text("\(self.helper.sprints[counter].title ?? "no title")")
                                        
                                    }
                                }
                            }else {
                                Text("No Sprints Available")
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
            
                }.navigationBarTitle("Create Issue")
                
            }
            
            Button(action: {
                self.saveTicket()
                self.isPresented = false
            }) {
                Text("Create Issue")
            }
            
        }
    }
    
    func saveTicket() {
        
        var newTicket = issue(title: self.title,
                                description: self.description,
                                issueID: 0,
                                points: self.storyPoints,
                                assignee: nil,
                                type: issueType(rawValue: self.selectedTypeString) ?? .none,
                                sprintID: nil,
                                epicID: nil,
                                status: .open,
                                timestamp: Timestamp(date: Date()))
        
        if selectedSprintIndex != -1 && helper.sprints.isEmpty == false {
            newTicket.sprintID = helper.sprints[self.selectedSprintIndex].sprintID
        }
        
        helper.saveIssue(ticket: newTicket)
    }
    
}

struct CreateTicket_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        CreateTicket(isPresented: $isPresented)
    }
}
