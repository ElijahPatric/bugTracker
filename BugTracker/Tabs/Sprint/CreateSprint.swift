//
//  CreateSprint.swift
//  BugTracker
//
//  Created by Elijah on 4/9/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
struct CreateSprint: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
    var upperStartLimit: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
    }
    let helper = IssueHelper(withListner:false)
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("title (optional)",text: $title)
                }
                Section {
                    VStack {
                        DatePicker(selection: $startDate, in: Date()...self.upperStartLimit, displayedComponents: [DatePickerComponents.date]) {
                            Text("Begin Time")
                        }
                        DatePicker(selection: $endDate, in: Date()..., displayedComponents: [DatePickerComponents.date]) {
                            Text("End Time")
                        }
                    }
                }
                Section {
                    Button(action: {
                        self.saveSprint()
                        self.isPresented = false
                        
                       
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Create Sprint")
                                .padding()
                            Spacer()
                        }
                        
                    }.overlay(Capsule(style: .continuous)
                    .stroke(Color.accentColor, lineWidth: 2))
                }
            }.navigationBarTitle("Create Sprint")
        }
    }
    func saveSprint() {
        
        let newSprint = sprint(
            sprintID: 0,
            duration: 0,
            startTimestamp: Timestamp(date: self.startDate),
            endTimestamp: Timestamp(date: self.endDate),
            title: self.title,
            description: "",
            points: 0)
        
        helper.saveSprint(sprint: newSprint)
        
    }
}

struct CreateSprint_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        CreateSprint(isPresented: $isPresented)
    }
}
