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
    @State var sprint = ""
    @State var isSelected = false
    @State var selectedTitle = ""
    @State private var scale: CGFloat = 1.2
    
    @Binding var isPresented: Bool
    @EnvironmentObject var issueObject: IssueHelper

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
//    let helper = IssueHelper(withListner:false)
    
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
                                
                                ForEach(0..<self.issueTypesArray.count) { counter in
                                    IssueTypeElement(titleText: self.issueTypesArray[counter]) { () -> ()? in
                                        self.isSelected = true
                                        self.selectedTitle = self.issueTypesArray[counter]
                                        self.selectedTypeString = self.issueTypesArray[counter]
                                        
                                        return nil
                                    }.scaleEffect(self.isSelected && self.selectedTitle == self.issueTypesArray[counter] ? self.scale : 1)
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
                            Picker(selection: $sprint, label: Text("Sprint")) {
                                ForEach(0..<4) {_ in 
                                    Text("Sprints")
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
                    
                    
//                    Section {
//                        Picker(selection: $selectedTypeIndex, label: Text("Issue Type")) {
//                            ForEach(0..<issueTypesArray.count) { i in
//                                Text(self.issueTypesArray[i]).tag(i)
//                            }
//                        }
//                    }
            
                }.navigationBarTitle("Create Issue")
                
            }
            
            Button(action: {
                self.saveTicket()
                self.isPresented = false
            }) {
                Text("Save")
            }
            
        }
    }
    
    func saveTicket() {
        
        let newTicket = issue(title: self.title,
                                description: self.description,
                                issueID: 0,
                                points: self.storyPoints,
                                assignee: nil,
                                type: issueType(rawValue: self.selectedTypeString) ?? .none,
                                sprintID: nil,
                                epicID: nil,
                                status: .open,
                                timestamp: Timestamp(date: Date()))
        
//          helper.saveIssue(ticket: newTicket)
        issueObject.saveIssue(ticket: newTicket)
    }
    
}

struct CreateTicket_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        CreateTicket(isPresented: $isPresented)
    }
}
