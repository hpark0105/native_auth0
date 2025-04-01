//
//  ContentView.swift
//  native_auth_0
//
//  Created by Hung Park on 3/31/25.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ContentView: View {
    @StateObject private var auth0Service = Auth0Service()
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningUp = false
    @State private var showPassword = false
    
    var body: some View {
        NavigationView {
            if auth0Service.isAuthenticated {
                // Authenticated view
                ScrollView {
                    VStack(spacing: 25) {
                        // Profile Header
                        VStack(spacing: 15) {
                            if let profile = auth0Service.userProfile {
                                // Profile Image
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Text(profile.name?.prefix(1).uppercased() ?? profile.email?.prefix(1).uppercased() ?? "U")
                                            .font(.system(size: 40, weight: .bold))
                                            .foregroundColor(.blue)
                                    )
                                
                                // User Info
                                VStack(spacing: 8) {
                                    Text(profile.name ?? "User")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text(profile.email ?? "No email")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.top, 30)
                        
                        // Stats Section
                        HStack(spacing: 30) {
                            StatView(title: "Member Since", value: "2024")
                            StatView(title: "Status", value: "Active")
                            StatView(title: "Role", value: "User")
                        }
                        .padding(.horizontal)
                        
                        // Action Buttons
                        VStack(spacing: 15) {
                            Button(action: {
                                // Add action here
                            }) {
                                HStack {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                    Text("Edit Profile")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            Button(action: {
                                // Add action here
                            }) {
                                HStack {
                                    Image(systemName: "bell")
                                    Text("Notifications")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                            }
                            
                            Button(action: {
                                auth0Service.logout()
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Logout")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 30)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Add settings action here
                        }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            } else {
                // Login/Signup view
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 15) {
                            Image(systemName: isSigningUp ? "person.badge.plus" : "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.blue)
                                .padding(.top, 40)
                            
                            Text(isSigningUp ? "Create Account" : "Welcome Back")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(isSigningUp ? "Join us to get started" : "Sign in to continue")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        // Form
                        VStack(spacing: 20) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                TextField("Enter your email", text: $email)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    if showPassword {
                                        TextField("Enter your password", text: $password)
                                    } else {
                                        SecureField("Enter your password", text: $password)
                                    }
                                    
                                    Button(action: {
                                        showPassword.toggle()
                                    }) {
                                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 8)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .textContentType(isSigningUp ? .newPassword : .password)
                            }
                            
                            if let errorMessage = auth0Service.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.top, 5)
                            }
                            
                            // Action Button
                            Button(action: {
                                if isSigningUp {
                                    auth0Service.signup(email: email, password: password)
                                } else {
                                    auth0Service.login(email: email, password: password)
                                }
                            }) {
                                HStack {
                                    Text(isSigningUp ? "Create Account" : "Sign In")
                                        .fontWeight(.semibold)
                                    Image(systemName: "arrow.right")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .padding(.top, 10)
                            
                            // Toggle Button
                            Button(action: {
                                withAnimation {
                                    isSigningUp.toggle()
                                }
                            }) {
                                HStack {
                                    Text(isSigningUp ? "Already have an account?" : "Don't have an account?")
                                        .foregroundColor(.gray)
                                    Text(isSigningUp ? "Sign In" : "Create Account")
                                        .foregroundColor(.blue)
                                        .fontWeight(.semibold)
                                }
                                .font(.subheadline)
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        // Social Login Options
                        VStack(spacing: 15) {
                            HStack {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray.opacity(0.3))
                                Text("Or continue with")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                auth0Service.loginWithGoogle()
                            }) {
                                HStack {
                                    Image(systemName: "g.circle.fill")
                                        .font(.title2)
                                    Text("Continue with Google")
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                auth0Service.loginWithApple()
                            }) {
                                HStack {
                                    Image(systemName: "apple.logo")
                                        .font(.title2)
                                    Text("Continue with Apple")
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
