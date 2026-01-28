# CleanMind — Technical Architecture (MVP)

## 1. Architecture Overview

CleanMind follows an **offline-first architecture with periodic synchronization**.

The app is designed to:
- Minimize mobile data usage
- Minimize battery consumption
- Operate reliably even with intermittent connectivity

Internet access is required, but backend communication is intentionally limited.

---

## 2. Main Components

### 2.1 Mobile Application (Flutter)

Platforms:
- iOS (phones only for MVP)
- Android (phones only for MVP)

Responsibilities:
- User interface and navigation
- Local storage of rules and counters
- VPN/DNS configuration and status
- Trigger unlock flows
- Display progress and achievements

The app does NOT contain critical business logic.

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

No passwords are stored or managed by CleanMind.

---

## 2.3 Backend Services (Firebase)

### Firestore (Database)

Stores:
- User profile and plan (Free / Pro)
- Progress counters
- Achievement state
- Accountability partners
- Preferences
- Domain list version metadata

---

### Cloud Functions (Business Logic)

Responsible for:
- Validating unlock requests
- Enforcing Free vs Pro limits
- Resetting counters
- Scheduling automatic unlock expiration
- Sending notifications
- Validating subscription status

Critical rules always execute server-side.

---

## 2.4 Blocking Engine (DNS-based)

MVP uses **DNS-based domain blocking**.

Characteristics:
- Domain-level filtering only
- No packet inspection
- No content analysis
- Lower battery and CPU usage
- Lower App Store rejection risk

---

## 3. Domain Database Strategy

### 3.1 Initial Sync

- On first app launch, the app downloads:
  - Pornographic domain list
  - Social media domain list
  - A version identifier (e.g. timestamp or version number)

- Domain lists are stored locally on the device.

---

### 3.2 Periodic Validation

The app checks for updates:
- On app launch
- Once per defined interval (e.g. daily)
- When user manually triggers a refresh

Only metadata (version info) is checked first.

If the version is unchanged:
- No full download occurs

---

### 3.3 Unknown Domains

If a domain is accessed that:
- Is not blocked
- Is not in the local database

The app may:
- Suggest the user to add the domain manually
- Optionally report the domain (without content inspection)

---

## 4. Connectivity Rules

The app connects to the backend only when necessary:
- Login and authentication
- Subscription validation
- Unlock requests
- Notifications
- Domain database updates

Blocking decisions use local data whenever possible.

---

## 5. Notifications

Provider:
- Firebase Cloud Messaging

Used for:
- Unlock events
- Automatic unlock expiration
- Achievement milestones
- Monthly motivational messages

Notifications are optional and configurable.

---

## 6. Subscriptions

- Managed exclusively via:
  - Apple App Store
  - Google Play Store

The app:
- Queries subscription status
- Backend validates entitlement
- Access is granted or revoked accordingly

---

## 7. Privacy Considerations

- No browsing history is stored
- No URLs are logged
- No message content is accessed
- Only domain categories and counters are processed
- All sensitive logic runs server-side

---

## 8. Error Handling

- If VPN/DNS fails:
  - User is notified
  - Protection status is clearly shown as OFF

- If backend is unreachable:
  - App continues using cached rules
  - Unlock requests are temporarily disabled

---

## 9. Versioning

- This document: v1.0
- Any architectural change requires a new version
