# Authentication Feature

## Overview
The Authentication feature provides secure user authentication and session management for the barber and salon finance app. It integrates with Firebase Authentication to provide email/password authentication, user session management, and secure data isolation between users.

## Key Components

### 1. Authentication Repository (`AuthRepository`)
**Purpose**: Handles all authentication operations and Firebase integration.

**Key Methods**:
- `getCurrentUser()`: Retrieves current authenticated user
- `signIn(email, password)`: Authenticates user with email/password
- `signUp(name, email, password)`: Creates new user account
- `sendPasswordReset(email)`: Sends password reset email
- `sendEmailVerification()`: Sends email verification
- `signOut()`: Signs out current user

**Important Implementation Details**:
- Firebase Authentication integration
- Email verification on account creation
- Password reset functionality
- User display name management
- Error handling for authentication failures

### 2. User Manager (`UserManager`)
**Purpose**: Centralized user session management and user ID handling.

**Key Properties**:
- `_currentUserId`: Current user's unique identifier
- `currentUserId`: Getter for current user ID with fallback
- `isSignedIn`: Boolean indicating authentication status
- `currentUser`: Current Firebase user object

**Important Implementation Details**:
- Singleton pattern for centralized user management
- Fallback user ID generation for development/testing
- Firebase user integration
- Session state management
- User ID persistence across app sessions

### 3. App Manager (`AppManager`)
**Purpose**: High-level application state management and user data handling.

**Key Properties**:
- `currentUser`: Current user model with profile data
- `isLoggedIn`: Authentication status indicator
- `_auth`: Firebase Authentication instance
- `_firestore`: Firebase Firestore instance

**Important Implementation Details**:
- Firebase Firestore integration for user profiles
- User data fetching and caching
- Authentication state listening
- Retry logic for user data loading
- Session management and cleanup

## Backend Architecture

### Firebase Authentication Integration
**Purpose**: Secure authentication using Firebase services.

**Firebase Services**:
- **Authentication**: Email/password authentication
- **Firestore**: User profile data storage
- **User Management**: Session and profile management

**Important Implementation Details**:
- Firebase project configuration
- Authentication state persistence
- Email verification workflow
- Password reset functionality
- Secure session management

### User Data Management
**Purpose**: User profile data storage and retrieval.

**Data Structure**:
- **User Profile**: Name, email, creation date
- **User Preferences**: Currency, settings, preferences
- **Data Isolation**: User-specific data separation

**Important Implementation Details**:
- Firestore document structure for user data
- User data caching for performance
- Retry logic for data loading failures
- Data validation and error handling
- User data synchronization

### Session Management
**Purpose**: Secure user session handling and persistence.

**Session Features**:
- **Automatic Login**: Persistent sessions across app restarts
- **Session Validation**: Authentication state verification
- **Secure Logout**: Complete session cleanup
- **State Synchronization**: Real-time authentication state updates

**Important Implementation Details**:
- Authentication state listeners
- Session persistence across app lifecycle
- Secure session cleanup on logout
- Real-time authentication state updates
- Error handling for session failures

## User Interface

### Authentication Screen (`AuthScreen`)
**Purpose**: Main interface for user authentication.

**Key Features**:
- **Sign In/Sign Up Toggle**: Switch between authentication modes
- **Email/Password Input**: Secure credential input
- **Name Input**: User display name for sign up
- **Authentication Actions**: Sign in, sign up, password reset
- **Loading States**: Visual feedback during authentication
- **Error Handling**: User-friendly error messages

**Important Implementation Details**:
- Form validation for email and password
- Secure password input with obscuring
- Loading indicators during authentication
- Error message display for authentication failures
- Navigation to home screen on successful authentication

### Onboarding Screen (`OnboardingScreen`)
**Purpose**: Welcome screen for new users.

**Key Features**:
- **App Introduction**: Welcome message and app overview
- **Authentication Navigation**: Links to sign in/sign up
- **Feature Highlights**: Key app features preview
- **User Guidance**: Getting started information

**Important Implementation Details**:
- Welcome message and app branding
- Clear navigation to authentication
- Feature highlights for user engagement
- Responsive design for different screen sizes

## Data Flow

### Authentication Flow
1. **User Input**: User enters credentials in authentication screen
2. **Validation**: System validates email and password format
3. **Firebase Authentication**: Credentials sent to Firebase
4. **User Creation/Login**: Firebase creates or authenticates user
5. **User Data Loading**: User profile data loaded from Firestore
6. **Session Setup**: User session established and user ID set
7. **Navigation**: User redirected to home screen

### Session Management Flow
1. **App Startup**: App checks for existing authentication
2. **Session Validation**: Firebase validates current session
3. **User Data Loading**: User profile data loaded if authenticated
4. **State Update**: Authentication state updated in app
5. **Navigation**: User redirected based on authentication status

### Logout Flow
1. **Logout Request**: User initiates logout
2. **Firebase Signout**: Firebase session terminated
3. **Local Cleanup**: Local user data cleared
4. **State Reset**: Authentication state reset
5. **Navigation**: User redirected to onboarding

## Security Features

### Firebase Security
**Purpose**: Enterprise-grade security through Firebase.

**Security Features**:
- **Encrypted Communication**: All data encrypted in transit
- **Secure Storage**: User data stored securely in Firebase
- **Authentication Tokens**: Secure token-based authentication
- **Session Management**: Secure session handling
- **Password Security**: Firebase handles password security

**Important Implementation Details**:
- Firebase security rules for data access
- Encrypted data transmission
- Secure authentication tokens
- Automatic session expiration
- Password security best practices

### Data Isolation
**Purpose**: Complete user data separation and privacy.

**Isolation Features**:
- **User-Specific Data**: All data filtered by user ID
- **Repository Isolation**: User-specific data access patterns
- **Local Storage Isolation**: User-specific local data
- **Session Isolation**: Complete session separation

**Important Implementation Details**:
- User ID filtering in all data operations
- Repository-level user isolation
- Local database user separation
- No cross-user data access

### Privacy Protection
**Purpose**: User privacy and data protection.

**Privacy Measures**:
- **Local Data Storage**: Financial data stored locally only
- **No Data Sharing**: No external data transmission
- **User Control**: User has complete control over their data
- **Secure Authentication**: Secure credential handling

## Error Handling

### Authentication Errors
**Purpose**: Graceful handling of authentication failures.

**Error Scenarios**:
- **Invalid Credentials**: Wrong email/password
- **Network Errors**: Connection failures
- **Account Issues**: Unverified accounts, disabled accounts
- **Firebase Errors**: Service unavailability

**Error Handling**:
- User-friendly error messages
- Retry mechanisms for network errors
- Clear guidance for account issues
- Fallback options for service failures

### Session Errors
**Purpose**: Handling session-related errors.

**Error Scenarios**:
- **Session Expiration**: Automatic session timeout
- **Token Refresh**: Authentication token refresh failures
- **Data Loading**: User data loading failures
- **State Synchronization**: Authentication state sync issues

**Error Handling**:
- Automatic session refresh
- Graceful degradation on data loading failures
- Clear error messages for user awareness
- Recovery mechanisms for state issues

## Performance Optimizations

### Authentication Performance
**Purpose**: Optimizes authentication and session management performance.

**Optimization Strategies**:
- **Cached User Data**: User profile data cached for quick access
- **Persistent Sessions**: Sessions persist across app restarts
- **Efficient State Management**: Optimized authentication state handling
- **Background Processing**: Non-blocking authentication operations

### Data Loading Optimization
**Purpose**: Efficient user data loading and management.

**Optimization Details**:
- **Lazy Loading**: User data loaded only when needed
- **Cached Data**: User profile data cached for performance
- **Retry Logic**: Intelligent retry for failed data loads
- **Background Sync**: User data synchronized in background

## Integration Points

### Repository Integration
**Purpose**: User authentication integrated with all data repositories.

**Integration Details**:
- All repositories use user ID for data isolation
- Authentication state affects data access
- User session management across all features
- Secure data access patterns

### UI Integration
**Purpose**: Authentication state integrated with all UI components.

**Integration Details**:
- Authentication state affects navigation
- User-specific UI customization
- Session state reflected in UI
- Secure UI access patterns

### Data Integration
**Purpose**: User authentication integrated with all data operations.

**Integration Details**:
- User ID filtering in all data queries
- Authentication validation for data access
- User-specific data storage and retrieval
- Secure data operation patterns

## Data Security and Privacy

### Local Data Security
**Purpose**: Ensures financial data remains secure and private.

**Security Measures**:
- **Local Storage**: All financial data stored locally on device
- **Device Encryption**: Data encrypted using device security
- **No External Transmission**: No financial data sent to external services
- **User Control**: User has complete control over their data

### Authentication Privacy
**Purpose**: Protects user authentication and profile data.

**Privacy Measures**:
- **Minimal Data Collection**: Only necessary authentication data collected
- **Secure Storage**: Authentication data stored securely in Firebase
- **No Tracking**: No user behavior tracking or analytics
- **User Control**: User controls their authentication data
