import Foundation

enum Auth0Config {
    static let domain = "hpark-sample-app.us.auth0.com"
    static let clientId = "K1A5YZeUqnRwcWALDrK1Upx69rVkwBoy"
    static let bundleIdentifier = "parkenstein.88.native-auth-0"
    
    static let callbackURL = "\(bundleIdentifier)://\(domain)/ios/\(bundleIdentifier)/callback"
} 