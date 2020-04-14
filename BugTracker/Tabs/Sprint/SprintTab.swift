//
//  SprintTab.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI

struct SprintTab: View {
    @State var presentSprint = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                Button(action: {
                    self.presentSprint.toggle()
                }) {
                    Text("Create New Sprint")
                      .multilineTextAlignment(.center)
                }.padding(.leading, CGFloat(8.0))
                 .sheet(isPresented: $presentSprint) {
                    CreateSprint(isPresented: self.$presentSprint)
                }
                    
            }
            Spacer()
        }
    }
}

struct SprintTab_Previews: PreviewProvider {
    static var previews: some View {
        SprintTab()
    }
}
