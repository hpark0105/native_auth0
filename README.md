# Native Auth0 iOS App

A SwiftUI-based iOS application demonstrating Auth0 authentication with email/password and social login options.

## Features

- Email/Password Authentication
- Social Login (Google, Apple)
- User Profile Management
- Secure Credential Storage
- Modern SwiftUI Interface

## Configuration

### Auth0 Setup

All Auth0-related configuration is centralized in `Config.swift`. This makes it easy to update settings and maintain consistency across the app.

#### Location
```
native_auth_0/Config.swift
```

#### Configuration Structure
```swift
enum Config {
    enum Auth0 {
        static let domain = "your-domain.auth0.com"
        static let clientId = "your-client-id"
        static let bundleIdentifier = "your.bundle.identifier"
        
        // Social Connections
        static let googleConnection = "google-oauth2"
        static let appleConnection = "apple"
        static let emailConnection = "email"
        
        // Database Connection
        static let databaseConnection = "Username-Password-Authentication"
    }
}
```

### Updating Auth0 Configuration

1. Open `Config.swift` in your preferred editor
2. Update the necessary values:
   - `domain`: Your Auth0 domain
   - `clientId`: Your Auth0 application client ID
   - `bundleIdentifier`: Your app's bundle identifier
   - Connection names (if needed)

3. After updating `Config.swift`, run the update script:
   ```bash
   ./native_auth_0/update_auth0_plist.sh
   ```

This will automatically update the `Auth0.plist` file with the new configuration values.

### Benefits of This Approach

1. **Single Source of Truth**
   - All Auth0 configuration is managed in one place
   - Reduces the chance of configuration mismatches
   - Makes it easier to track changes

2. **Easy Updates**
   - Modify settings in one file
   - Automatic plist file updates
   - No need to manually edit multiple files

3. **Type Safety**
   - Swift enums provide type-safe configuration
   - Compile-time checking of configuration values
   - Better IDE support with autocompletion

4. **Better Organization**
   - Clear separation of configuration and implementation
   - Grouped related settings together
   - Easy to add new configuration options

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- Auth0 SDK

## Installation

1. Clone the repository
2. Open the project in Xcode
3. Add your Auth0 credentials in `Config.swift`
4. Run the update script to generate the plist file
5. Build and run the project

## Auth0 Dashboard Setup

1. Create a new application in your Auth0 dashboard
2. Configure the following settings:
   - Allowed Callback URLs: `your.bundle.identifier://your-domain.auth0.com/ios/your.bundle.identifier/callback`
   - Bundle Identifier: Match the one in `Config.swift`
3. Enable the necessary connections (Google, Apple, etc.)

## License

This project is licensed under the MIT License - see the LICENSE file for details. 