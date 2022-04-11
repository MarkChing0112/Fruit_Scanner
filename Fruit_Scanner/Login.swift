//
//  Login.swift
//  Fruit_Scanner
//
//  Created by Isaac Lee on 11/4/2022.
//

import SwiftUI

struct Login: View {
    
    @StateObject var loginModel: LoginView = LoginView()
    // FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false
    var body: some View {
        VStack{
            
            Circle()
                .trim(from: 0, to: 0.5)
                .fill(.black)
                .frame(width: 45, height: 45)
                .rotationEffect(.init(degrees: -90))
                .hLeading()
                .offset(x: -23)
                .padding(.bottom, 30)
            
            Text("Hey, \nLogin Now")
                .font(.largeTitle.bold())
                .foregroundColor(.black)
                .hLeading()
            
            TextField("Email", text: $loginModel.email)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            loginModel.email == "" ? Color.black.opacity(0.05): Color("Orange"))
                    
                }
                .textInputAutocapitalization(.never)
                .padding(.top, 20)
            
            TextField("Password", text: $loginModel.password)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            loginModel.password == "" ? Color.black.opacity(0.05): Color("Orange"))
                    
                }
                .textInputAutocapitalization(.never)
                .padding(.top, 15)
            
            // User Prompt to ask to store Login using FaceID on next time
            Group {
                if useFaceID {
                    
                    Button {
                        // Do FaceID Action
                        Task{
                            do{
                                try await loginModel.loginUser()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        
                    }label: {
                        VStack(alignment: .leading, spacing: 10) {
                            Label {
                                Text("Use FcaeID to login into previous account")
                                
                            } icon: {
                                Image(systemName: "faceid")
                                
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                            
                            Text("Note: You can trun of it in settings !")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    .hLeading()
                    
                } else {
                    Toggle(isOn: $useFaceID) {
                        Text("Use FaceID to Login")
                    }
                }
            }

            Button{
                
            } label: {
                Text("Login")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .hCenter()
                    .background {
                        RoundedRectangle(cornerRadius: 8).fill(Color(.brown))
                    }
            }
            .padding(.vertical, 35)
            .disabled(loginModel.email == "" || loginModel.password == "")
            .opacity(loginModel.email == "" || loginModel.password == "" ? 0.5 : 1)
            
            
        }
        .padding(.horizontal, 25)
        .padding(.vertical)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

// Extensions for UI Designing
extension View{
    
    func hLeading()-> some View{
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing()-> some View{
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter()-> some View{
        self.frame(maxWidth: .infinity, alignment: .center)
    }
}
