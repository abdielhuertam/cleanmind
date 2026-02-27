# CleanMind — Technical Architecture (MVP)

## 1. Architecture Overview

CleanMind follows a **backend-validated architecture with local state persistence**.

The app is designed to:
- Maintain reliable local protection state
- Delegate critical unlock logic to the backend
- Enforce plan rules server-side
- Support SMS-based verification and Support approval

Internet access is required for all unlock-related flows.

Protection activation and DNS blocking remain locally enforced.

---

## 2. Main Components

### 2.1 Mobile Application (Flutter)

Platforms:
- iOS (phones only for MVP)
- Android (phones only for MVP)

Responsibilities:
- User interface and navigation
- Local storage of protection state
- VPN/DNS configuration and status
- Initiating unlock requests
- Displaying approval status
- Displaying Activity Log
- Handling SMS code entry
- Rendering Support approval screens

The app does NOT make final unlock decisions.
All critical unlock validation is performed server-side.

---

## 2.2 Authentication

Provider:
- Firebase Authentication

Methods:
- Sign in with Apple
- Sign in with Google

Stored data:
- User ID
- Email
- Account creation date

Authentication is required for:
- Unlock requests
- Support approval
- Activity logging
- Plan validation

---

## 2.3 Backend Services (Firebase)

### Firestore (Database)

Stores:
- User profile
- Plan type (Free / Pro)
- Support relationship
- Unlock requests
- Verification codes (hashed)
- Activity logs
- Preferences
- Domain list version metadata

---

### Cloud Functions (Business Logic)

Responsible for:
- Generating verification codes
- Sending SMS via provider
- Creating unlock requests
- Validating verification codes
- Processing Support approval or rejection
- Enforcing plan restrictions
- Logging approval and unlock events
- Validating subscription status

All unlock transitions to protectionDisabled must be validated server-side.

---

### SMS Provider Integration

An external SMS provider is integrated via backend.

Responsibilities:
- Deliver verification codes
- Send approval-related notifications (when required)

SMS sending is triggered only after explicit user confirmation.

---

## 2.4 Blocking Engine (DNS-based)

MVP uses **DNS-based domain blocking**.

Characteristics:
- Domain-level filtering only
- No packet inspection
- No content analysis
- Lower battery and CPU usage
- Lower App Store rejection risk

Blocking decisions are local and independent of backend connectivity.

---

## 3. Domain Database Strategy

### 3.1 Initial Sync

- On first app launch, the app downloads:
  - Pornographic domain list
  - Social media domain list
  - A version identifier

- Domain lists are stored locally on the device.

---

### 3.2 Periodic Validation

The app checks for updates:
- On app launch
- Once per defined interval
- When user manually triggers refresh

Only metadata is checked first.

If unchanged:
- No full download occurs.

---

### 3.3 Unknown Domains

If a domain is accessed that:
- Is not blocked
- Is not in the local database

The app may:
- Suggest manual addition
- Optionally report metadata (without content inspection)

---

## 4. Connectivity Rules

The app connects to the backend for:

- Authentication
- Subscription validation
- Unlock request creation
- Verification code validation
- Support approval processing
- Activity log synchronization
- Push notification handling
- Domain database metadata updates

Protection activation and DNS enforcement remain functional offline.

Unlock requests require backend connectivity.

---

## 5. Notifications

Provider:
- Firebase Cloud Messaging

Used for:
- Support approval requests
- Unlock approval confirmation
- Rejection notifications
- Activity log updates
- Motivational reminders

Notifications are configurable.

---

## 6. Subscriptions

- Managed exclusively via:
  - Apple App Store
  - Google Play Store

The app:
- Queries subscription status
- Backend validates entitlement
- Pro features are enabled or disabled accordingly

Unlock methods are restricted based on validated plan status.

---

## 7. Privacy Considerations

- No browsing history is stored
- No URLs are logged
- No message content is accessed
- SMS content is limited to neutral verification messages
- Verification codes are stored securely
- Approval logs contain timestamps only (no browsing data)

Sensitive business logic executes server-side.

---

## 8. Error Handling

- If VPN/DNS fails:
  - User is notified
  - Protection status is clearly shown as OFF

- If backend is unreachable:
  - Protection remains ACTIVE
  - Unlock requests are disabled
  - Waiting periods cannot be initiated
  - User is informed that approval requires connectivity

- If SMS delivery fails:
  - Unlock remains pending
  - User may retry sending

---

## 9. Local State Persistence (v2)

CleanMind uses local device storage via SharedPreferences to persist:

- ProtectionStatus
- activatedAt timestamp
- isPro flag
- deactivationScheduledAt (Free / Pro without Support)

On app launch:

1. main.dart initializes asynchronously.
2. LocalStorageService.loadPlan() reconstructs PlanState.
3. HomeScreen renders after state restoration.
4. Backend is queried if unlock status is pending approval.

This ensures:

- Counter continuity across restarts
- Accurate unlock state synchronization
- Stable state-driven architecture

---

## 10. Versioning

- This document: v2.0 (Backend-validated MVP)
- Any architectural change requires a new version