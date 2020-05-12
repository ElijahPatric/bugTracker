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
import Firebase
struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var authSuccess = false
    @ObservedObject var appleSignInDelegates: SignInWithAppleDelegate = SignInWithAppleDelegate()
//        { success in
//        if success {
//
//            print("got success on content view 🤓")
//            //self.needsToSignIn = false
//        }else {
//            print("did not get success on content view 🤓")
//            //self.needsToSignIn = true
//        }
//    }
    
    var isLoggedIn: Bool {
        get {
            return Auth.auth().currentUser != nil
        }
    }
    
    var body: some View {
        
        Group { if self.appleSignInDelegates.isLoggedIn == false  {
        
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
    }else {
          ContentView()
        }
        }
    }
    
    func showAppleLogin() {
        
//        appleSignInDelegates = SignInWithAppleDelegate() { success in
//            if success {
//
//                print("got success on loginView 🤓")
//                self.appleSignInDelegates.loginErrorOccurred = false
//                self.appleSignInDelegates.isLoggedIn = true
//                self.authSuccess = true
//
//            }else {
//                print("did not get success on loginView 🤓")
//                self.appleSignInDelegates.loginErrorOccurred = true
//                self.appleSignInDelegates.isLoggedIn = false
//                self.authSuccess = false
//            }
//        }
        
        let nonce = self.appleSignInDelegates.randomNonceString()
        self.appleSignInDelegates.currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = self.appleSignInDelegates.sha256(nonce)
        
        
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleSignInDelegates
        controller.performRequests()
        
    }
    
//    private func performAuthCheck() {
//
//
//        let provider = ASAuthorizationAppleIDProvider()
//
//        provider.getCredentialState(forUserID: "currentUserIdentifier") { (state, error) in
//
//
//            switch state {
//            case .authorized :
//                    //credentials are valid, no action needed
//                    self.appleSignInDelegates.loginErrorOccurred = false
//                    print("credentials are valid (login view)🤓")
//
//                break
//
//            case .notFound :
//                    // credentials not found. Ask to Log In
//                    print("credentials not found (login view)🤓")
//
//                break
//
//            case .revoked :
//                    //credentials revoked. Log them out
//
//                break
//
//            case .transferred :
//                    // not sure what this is. Ask them to log in
//
//                print("credentials transferred (login view)🤓")
//                break
//
//            default :
//                    // all other cases, ask them to log in
//                break
//
//            }
//
//        }
//
//    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
