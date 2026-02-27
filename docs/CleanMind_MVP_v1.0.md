# CleanMind — MVP v2.0

## 1. Product Overview

CleanMind is a mobile application designed to help users intentionally reduce access to pornographic content and distracting digital platforms through friction, accountability, and conscious decision-making.

The app combines local protection enforcement with backend-validated accountability mechanisms.

The product focuses on creating intentional pauses, visibility, and structured support rather than punishment or shame.

---

## 2. Target Users

- Adults seeking digital detox
- Young adults
- Parents who install the app on their children’s devices
- Users who value structured accountability over restriction alone

The app maintains a neutral, non-religious tone.

---

## 3. Core Principles

- Friction over force  
- Accountability over punishment  
- Visibility over secrecy  
- Progress over perfection  
- No shame-based UX  
- Server-validated unlock logic  

---

## 4. Platforms (MVP Scope)

- iOS (phones only)
- Android (phones only)

Tablets, iPads, web dashboards, and desktop clients are out of scope for the MVP.

---

## 5. Core Features (MVP)

- VPN/DNS-based content blocking
- Explicit protection activation
- Backend-validated unlock flows
- SMS-based verification codes
- Optional Support approval system
- Activity logging for approval events
- Free and Pro subscription tiers

---

## 6. Protection Model

- Protection is NOT activated automatically after installation
- The user must explicitly activate protection
- Once activated, protection remains ON by default
- Protection can only be disabled through intentional, validated actions
- Unlock transitions are validated server-side when required

---

## 7. Unlock & Deactivation Philosophy

CleanMind differentiates between:

- **Waiting Period Unlock** (Free and Pro without Support)
- **SMS Verification Unlock**
- **Support Approval Unlock (App-based)**

Total protection deactivation:

- Requires explicit user intent
- May require external verification (SMS or Support approval)
- Does NOT restore automatically
- Is always visible
- Is logged in backend when Support is configured

There is no automatic reactivation.

---

## 8. Free vs Pro

### Free Plan

- Pornographic content blocking
- Blocking of one social media platform
- Copy Challenge
- Fixed 8-hour waiting period for protection deactivation
- Basic progress tracking
- No Support configuration
- No automatic SMS sending

### Pro Plan

Includes everything in Free, plus:

- Configurable waiting period (minimum 1 hour) when no Support is configured
- SMS-based verification codes
- Optional Support configuration
- Mandatory Support approval when configured
- Activity logging for unlock and approval events
- Access to extended blocking customization (planned within MVP scope)

---

## 9. Support Role (Pro Only)

Pro users may configure a Support contact.

When Support is configured:

- Waiting period is disabled
- Copy Challenge is disabled
- Unlock requires Support approval

Two Support modes are supported:

1. Support with CleanMind app installed  
   - Receives push notification  
   - Must authenticate  
   - Can approve or reject  
   - All actions logged  

2. Support without app  
   - Receives SMS with verification code  
   - Code must be entered in the app  
   - Backend validates before unlock  

Support approval is mandatory in this configuration.

---

## 10. Privacy & Legal (MVP)

- CleanMind does not inspect browsing content
- CleanMind does not log specific URLs
- CleanMind does not read personal messages
- SMS messages contain neutral, non-incriminatory language
- Verification codes are time-limited and single-use
- Approval logs contain timestamps only (no browsing history)

---

## 11. Out of Scope (Post-MVP)

- Tablet and iPad support
- Advanced analytics dashboards
- Multi-profile parental management
- Desktop or web-based blocking
- Community group integrations

---

## 12. Versioning

- This document version: v2.0 (Backend-Validated MVP)
- Any product scope changes require a new version