# CleanMind — Product Flow (MVP)

This document describes the end-to-end user experience and core interaction loops
of the CleanMind mobile application.

This file reflects CLOSED product decisions and must stay aligned with
Business_Rules.md and the codebase.

---

## 1. First Launch & Language Selection

- On first launch, the user is prompted to select a language.
- Supported languages (MVP):
  - English
  - Spanish
  - French
  - Portuguese
- The selected language:
  - Is stored locally
  - Applies to all UI copy and motivational messages
  - Can be changed later from Settings

---

## 2. Initial State (Protection Inactive)

- The app always starts with protection **OFF**.
- No blocking is applied until the user activates protection.
- No counters are running.

Primary CTA:
> Activate Protection

---

## 3. Protection Active State

When protection is active:

- Content blocking is enforced
- Progress counters increment daily
- The Home screen clearly displays:
  - Protection status: ON
  - Current streak (days of consistency)

Primary actions:
- Request Temporary Unlock
- View progress

---

## 4. Request Temporary Unlock — Entry Point

When the user taps **Request Temporary Unlock**:

1. The app displays a clear warning:
   > “If you continue, your progress counter will reset.”

2. The user must explicitly confirm to proceed.

3. The user is presented with the available unlock methods
   based on their current plan and Support configuration.

---

## 5. Unlock Methods Overview

Unlock behavior depends on the user’s plan and whether a Support is configured.

### Free Plan

Available methods:

- Copy Challenge
- 8-hour Waiting Period

Behavior:

- Protection remains ACTIVE during the waiting period.
- Protection automatically disables when the waiting period expires.
- No external notifications are sent.

---

### Pro Plan (No Support Configured)

Available methods:

- Copy Challenge
- Configurable Waiting Period (minimum 1 hour)
- Accountability Code via SMS

Behavior:

- Waiting Period automatically disables protection when it expires.
- Accountability Code sends an automatic SMS containing a verification code.
- Protection disables only after successful code validation.

---

### Pro Plan (Support Configured)

If a Support contact is configured:

- Waiting Period is disabled.
- Copy Challenge is disabled.
- Unlock requires mandatory Support approval.

Two approval paths are available:

1. Support with CleanMind app installed
2. Support without app (SMS code verification)

Protection remains ACTIVE until approval is completed.

---

## 6. Accountability Code Flow (Pro — No Support or SMS-Based Support)

- The user requests immediate unlock.
- The backend generates a temporary verification code.
- An automatic SMS is sent to the configured contact.
- The contact receives a discreet message with a verification code.
- The user must enter the received code.
- The backend validates the code.

Outcomes:

- Correct code → Protection disabled
- Incorrect or expired code → Protection remains active

Notes:

- Codes are generated server-side.
- Codes expire after a defined time window.
- CleanMind does not read incoming messages.

---

## 7. Support Approval Flow (Pro — Support Configured)

When a Support is configured:

1. The user requests deactivation.
2. Protection remains ACTIVE.
3. A Support approval request is created in the backend.

### If Support has the app installed:

- Support receives a push notification.
- Support must authenticate (PIN or biometric).
- Support can Approve or Reject.
- All actions are logged in an Activity Log.

If approved:

- User sees confirmation screen:
  > “Your Support has approved this request.”
- User confirms final deactivation.
- Protection disables.
- Event is recorded in history.

If rejected:

- Protection remains active.

---

### If Support does not have the app installed:

- A verification code is generated server-side.
- An automatic SMS is sent to Support.
- Support shares the code verbally.
- User enters the code.
- Backend validates.
- Protection disables upon successful validation.

All events are logged.

---

## 8. Protection Disabled State

When protection is disabled:

- Blocking is fully off
- Progress counters are paused
- The Home screen displays:
  - Protection status: OFF
  - Time since deactivation

Primary CTA:
> Activate Protection

---

## 9. Motivational Reminders

While protection is disabled:

- Optional motivational reminders may be sent
- Available intervals:
  - Every 1 hour
  - Every 3 hours
  - Every 12 hours
  - Every 24 hours
- Reminders are:
  - Optional
  - Supportive
  - Non-judgmental
- Reminders do NOT change protection state

---

## 10. Manual Reactivation Flow

- The user manually activates protection.
- Upon activation:
  - Blocking resumes
  - Progress tracking restarts
  - If Support is configured, activation is logged in history

---

## 11. User Core Loop (Updated)

### Free

1. Protection OFF
2. User activates protection
3. Protection ON
4. User requests unlock (friction or waiting period)
5. Protection OFF
6. User manually reactivates protection

---

### Pro without Support

1. Protection ON
2. User requests unlock
3. Waiting Period or SMS code verification
4. Protection OFF

---

### Pro with Support

1. Protection ON
2. User requests unlock
3. Support approval required
4. Protection OFF only after approval

---

## 12. Versioning

This document reflects CLOSED MVP behavior including backend-based approval and SMS verification.

Any future changes must be logged in Development_Log.md.