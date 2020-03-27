//
//  IssueActionOptions.swift
//  BugTracker
//
//  Created by Elijah on 3/26/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI

struct IssueActionOptions: View {

@State var editClosure: () -> ()

    var body: some View {
        HStack {
            
                Button(action: {
                    
                }) {
                    Text("Edit")
                        .font(Font.largeTitle)
                }.onTapGesture {
                    self.editClosure()

            }
            
          
            
        }
    }
}

struct IssueActionOptions_Previews: PreviewProvider {
    static var previews: some View {
        IssueActionOptions(editClosure: {
            print("hello Issue")
        })
    }
}
