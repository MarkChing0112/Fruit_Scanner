//
//  LoginView.swift
//  Fruit_Scanner
//
//  Created by Isaac Lee on 11/4/2022.
//

import SwiftUI
import Firebase

class LoginView: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    // FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false
    @AppStorage("use_face_email") var FaceIDEmail: String = ""
    @AppStorage("use_face_password") var FaceIDPassword: String = ""
    
    // Log Status
    @AppStorage("use_face_id") var logStatus: Bool = false
    
    // Firebase Login
    func loginUser()async throws{
        
        let _ = try await Auth.auth().signIn(withEmail: email, password: password)
        
        if useFaceID{
            
            // Storing for future FaceID Login
            FaceIDEmail = email
            FaceIDPassword = password
        }
        logStatus = true
    }
}
