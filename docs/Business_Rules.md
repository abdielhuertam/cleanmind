# CleanMind — Product Flow (MVP)

This document describes the user experience and screen-level flow of the CleanMind app.

---

## 1. First Launch & Language Selection

- On first launch, users are prompted to select their preferred language.
- Supported languages for MVP:
  - English
  - Spanish
  - French
  - Portuguese
- Language selection:
  - Is stored locally
  - Can be changed later in Settings
  - Applies to all UI text and motivational messages

---

## 2. Initial State

- The app starts with protection set to OFF.
- No content is blocked until the user activates protection.

Primary action:
> Activate Protection

---

## 3. Active Protection State

When protection is active:
- Blocking is enforced
- Progress counters increment daily
- The Home screen clearly displays protection status

Primary actions:
- Request Temporary Unlock
- Deactivate Protection (with friction)

---

## 4. Request Temporary Unlock Flow

When the user requests a temporary unlock:

1. The app displays a warning:
> “If you continue, your progress counter will reset.”

2. The user selects one of the available unlock methods based on plan:
- Copy Challenge
- Accountability Code
- Time-based Unlock (Pro)

---

## 5. Copy Challenge Flow

- A phrase is displayed.
- The user must type it exactly.
- A countdown timer is visible.
- Success unlocks protection.
- Failure or timeout returns to protected state.

---

## 6. Accountability Code Flow

- The user chooses a trusted contact.
- A temporary unlock code is generated.
- The message sent to the contact is discreet and supportive.

Example:
> “{Name} is doing a digital detox and is asking for your help.”

- The user enters the received code to proceed.

---

## 7. Time-Based Unlock Flow (Pro)

- The user selects an intended unlock duration:
  - 15 minutes
  - 30 minutes
  - 1 hour
  - 2 hours
  - 4 hours
  - 8 hours

- The duration serves as an intention reminder only.
- Protection does NOT reactivate automatically.
- Protection remains disabled until the user manually re-enables it.

---

## 8. Protection Disabled State

- Protection is fully disabled.
- The Home screen shows:
  - Protection OFF
  - Time since deactivation
  - Intended duration (if selected)

Primary action:
> Activate Protection

---

## 9. Manual Reactivation Flow

- When the user activates protection:
  - Protection state becomes active
  - Progress tracking resumes
  - Accountability contact is notified

Example notification:
> “{Name} has turned protection back on in CleanMind.”

---

## 10. Motivational Reminders

- While protection is disabled, optional reminders may be sent.
- Reminder intervals are user-configurable.
- Reminders are supportive and informational.

---

## 11. Completion of the Loop

- Once protection is active again:
  - The user returns to the standard protected state
  - The loop is complete

---

## 12. Versioning

This document must remain aligned with Business Rules and the codebase.
