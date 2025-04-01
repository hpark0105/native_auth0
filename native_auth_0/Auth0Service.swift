import Foundation
import Auth0

class Auth0Service: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userProfile: UserInfo?
    @Published var errorMessage: String?
    
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePassword(_ password: String) -> Bool {
        // Password must be at least 8 characters long and contain at least one number
        return password.count >= 8 && password.contains(where: { $0.isNumber })
    }
    
    func signup(email: String, password: String) {
        print("🔐 Starting Auth0 signup process...")
        
        // Validate email and password
        guard validateEmail(email) else {
            self.errorMessage = "Please enter a valid email address"
            return
        }
        
        guard validatePassword(password) else {
            self.errorMessage = "Password must be at least 8 characters long and contain at least one number"
            return
        }
        
        Auth0
            .authentication()
            .signup(
                email: email,
                password: password,
                connection: "Username-Password-Authentication",
                userMetadata: ["first_name": "", "last_name": ""]
            )
            .start { [weak self] result in
                switch result {
                case .success(let user):
                    print("✅ Successfully created user")
                    print("👤 User email: \(user.email ?? "Not available")")
                    // After successful signup, automatically log in
                    self?.login(email: email, password: password)
                case .failure(let error):
                    print("❌ Signup failed with error: \(error)")
                    print("❌ Error details: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
    }
    
    func login(email: String, password: String) {
        print("🔐 Starting Auth0 native login process...")
        Auth0
            .authentication()
            .login(
                usernameOrEmail: email,
                password: password,
                realmOrConnection: "Username-Password-Authentication"
            )
            .start { [weak self] result in
                switch result {
                case .success(let credentials):
                    print("✅ Successfully received credentials")
                    print("📝 Access Token: \(credentials.accessToken.prefix(10))...")
                    print("📝 ID Token: \(credentials.idToken.prefix(10))...")
                    self?.credentialsManager.store(credentials: credentials)
                    self?.isAuthenticated = true
                    self?.getUserProfile()
                case .failure(let error):
                    print("❌ Login failed with error: \(error)")
                    print("❌ Error details: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
    }
    
    func logout() {
        print("🔓 Starting logout process...")
        credentialsManager.revoke { [weak self] result in
            switch result {
            case .success:
                print("✅ Successfully logged out")
                self?.isAuthenticated = false
                self?.userProfile = nil
            case .failure(let error):
                print("❌ Logout failed with error: \(error)")
                print("❌ Error details: \(error.localizedDescription)")
            }
        }
    }
    
    private func getUserProfile() {
        print("👤 Fetching user profile...")
        credentialsManager.credentials { [weak self] result in
            switch result {
            case .success(let credentials):
                print("✅ Successfully retrieved stored credentials")
                Auth0
                    .authentication()
                    .userInfo(withAccessToken: credentials.accessToken)
                    .start { [weak self] result in
                        switch result {
                        case .success(let profile):
                            print("✅ Successfully retrieved user profile")
                            print("👤 User email: \(profile.email ?? "Not available")")
                            print("👤 User name: \(profile.name ?? "Not available")")
                            self?.userProfile = profile
                        case .failure(let error):
                            print("❌ Failed to get user profile: \(error)")
                            print("❌ Error details: \(error.localizedDescription)")
                        }
                    }
            case .failure(let error):
                print("❌ Failed to retrieve credentials: \(error)")
                print("❌ Error details: \(error.localizedDescription)")
            }
        }
    }
    
    func loginWithApple() {
        print("🔐 Starting Apple login process...")
        Auth0
            .webAuth()
            .connection("apple")
            .start { [weak self] result in
                switch result {
                case .success(let credentials):
                    print("✅ Successfully received credentials from Apple")
                    self?.credentialsManager.store(credentials: credentials)
                    self?.isAuthenticated = true
                    self?.getUserProfile()
                case .failure(let error):
                    print("❌ Apple login failed with error: \(error)")
                    self?.errorMessage = error.localizedDescription
                }
            }
    }
    
    func loginWithGoogle() {
        print("🔐 Starting Google login process...")
        Auth0
            .webAuth()
            .connection("google-oauth2")
            .start { [weak self] result in
                switch result {
                case .success(let credentials):
                    print("✅ Successfully received credentials from Google")
                    self?.credentialsManager.store(credentials: credentials)
                    self?.isAuthenticated = true
                    self?.getUserProfile()
                case .failure(let error):
                    print("❌ Google login failed with error: \(error)")
                    self?.errorMessage = error.localizedDescription
                }
            }
    }
    
    func loginWithEmail() {
        print("🔐 Starting email login process...")
        Auth0
            .webAuth()
            .connection("email")
            .start { [weak self] result in
                switch result {
                case .success(let credentials):
                    print("✅ Successfully received credentials from email")
                    self?.credentialsManager.store(credentials: credentials)
                    self?.isAuthenticated = true
                    self?.getUserProfile()
                case .failure(let error):
                    print("❌ Email login failed with error: \(error)")
                    self?.errorMessage = error.localizedDescription
                }
            }
    }
} 