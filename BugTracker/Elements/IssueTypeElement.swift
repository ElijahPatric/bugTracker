//
//  FilterElement.swift
//  StartAParty
//
//  Created by Elijah on 11/19/19.
//  Copyright © 2019 Elijah Patric. All rights reserved.
//

import SwiftUI

struct IssueTypeElement: View {
    var standardHeight: CGFloat = 35.0
    var standardLength: CGFloat {
        get {
            standardHeight * 2.00
        }
    }
    var modifier = 0.7
    @State var titleText : String
    @State var buttonAction: () -> ()?
    var body: some View {
        
        ZStack {
           Rectangle()
            .frame(width: standardLength, height: standardHeight, alignment: .center)
            Button(action: {
                
                self.buttonAction()
            }) {
                Text(titleText)
                    .frame(width: standardLength, height: standardHeight, alignment: .center)
                    .font(Font.system(.body, design: .rounded))
                    
            }
        }
    }
    
}

struct IssueTypeElement_Previews: PreviewProvider {
    static var previews: some View {
        
        IssueTypeElement(titleText: "Feature", buttonAction: {})
    }
}
