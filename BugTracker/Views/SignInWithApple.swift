//
//  SignInWithApple.swift
//  BugTracker
//
//  Created by Elijah on 5/4/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//


import SwiftUI
import AuthenticationServices

final class SignInWithApple: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        
        return ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: UIViewRepresentableContext<SignInWithApple>) {
        
        
        
    }
    
    
}
