import Foundation

enum Config {
    enum Auth0 {
        static let domain = "hpark-sample-app.us.auth0.com"
        static let clientId = "K1A5YZeUqnRwcWALDrK1Upx69rVkwBoy"
        static let bundleIdentifier = "parkenstein.88.native-auth-0"
        
        static let callbackURL = "\(bundleIdentifier)://\(domain)/ios/\(bundleIdentifier)/callback"
        
        // Social Connections
        static let googleConnection = "google-oauth2"
        static let appleConnection = "apple"
        static let emailConnection = "email"
        
        // Database Connection
        static let databaseConnection = "Username-Password-Authentication"
    }
} 