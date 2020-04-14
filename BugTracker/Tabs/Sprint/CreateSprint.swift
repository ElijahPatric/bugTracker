//
//  CreateSprint.swift
//  BugTracker
//
//  Created by Elijah on 4/9/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI

struct CreateSprint: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
    var upperStartLimit: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
    }
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
}

struct CreateSprint_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        CreateSprint(isPresented: $isPresented)
    }
}
