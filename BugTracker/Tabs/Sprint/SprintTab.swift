//
//  SprintTab.swift
//  BugTracker
//
//  Created by Elijah on 2/10/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI

struct SprintTab: View {
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                Button(action: {
                    
                }) {
                    Text("Create New Sprint")
                      .multilineTextAlignment(.center)
                }.padding(.leading, CGFloat(8.0))
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
