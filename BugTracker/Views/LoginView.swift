//
//  LoginView.swift
//  BugTracker
//
//  Created by Elijah on 4/3/20.
//  Copyright © 2020 Elijah Patric. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State var appleSignInDelegates: SignInWithAppleDelegate! = nil

    var body: some View {
        VStack {
            Text("Basic Bug Tracker")
                .font(.largeTitle)
                .font(Font.system(.title, design: .rounded))
                
            Form {
                Section {
                    TextField("password", text: $password)
                }
                Section {
                    SecureField("username", text: $username)
                }
                Section {
                    Button(action: {
                        
                       
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Login")
                                .padding()
                                
                                    
                                
                            Spacer()
                        }
                        
                    }.overlay(Capsule(style: .continuous)
                    .stroke(Color.accentColor, lineWidth: 2))
                }
                
                Section {
                    HStack {
                        Spacer()
                        SignInWithApple()
                            .frame(width:280, height: 60,alignment: .center)
                            .onTapGesture {
                                self.showAppleLogin()
                        }
                        Spacer()
                    }
                        
                }
                
            }
            
        }
    }
    
    private func showAppleLogin() {
        //let request = ASAuthorizationAppleIDProvider().createRequest()
        //request.requestedScopes = [.fullName, .email]
        //request.nonce = sha256(nonce)
        
        let nonce = self.appleSignInDelegates.randomNonceString()
        self.appleSignInDelegates.currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = self.appleSignInDelegates.sha256(nonce)
        
        appleSignInDelegates = SignInWithAppleDelegate() { success in
            if success {
              
                print("got success on loginView 🤓")
                
            }else {
                print("did not get success on loginView 🤓")
            }
        }
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleSignInDelegates
        controller.performRequests()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
