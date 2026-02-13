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
   based on their current plan.

---

## 5. Unlock Methods Overview

Available unlock methods:

- Copy Challenge
- Accountability Code
- Time-based Unlock (Pro)

All unlock methods:
- Disable protection immediately upon success
- Do NOT schedule automatic reactivation

---

## 6. Copy Challenge Flow

- A motivational phrase is displayed.
- Autocorrect and autocomplete are disabled.
- The user must type the phrase exactly.
- A visible countdown timer is shown.

Outcomes:
- Success → Protection disabled
- Failure / timeout → Return to protected state

---

## 7. Accountability Code Flow (Discreet Support)

- The user selects a trusted contact.
- The app generates a temporary unlock code.
- The app prepares a **discreet, non-incriminatory message**.

Example message:
> “{Name} is doing a digital detox and is asking for your help.”

- The user sends the message manually (e.g., via WhatsApp).
- The user enters the received code to disable protection.

Notes:
- SMS is not supported in the MVP.
- CleanMind does not read or store any messages.

---

## 8. Time-based Unlock Flow (Pro)

- The user selects an intended unlock duration:
  - 15 minutes
  - 30 minutes
  - 1 hour
  - 2 hours
  - 4 hours
  - 8 hours

Important:
- The duration is **intentional only**
- Protection is NOT reactivated automatically
- Protection remains disabled until the user manually re-enables it

---

## 9. Protection Disabled State

When protection is disabled:

- Blocking is fully off
- Progress counters are paused
- The Home screen displays:
  - Protection status: OFF
  - Time since deactivation
  - Intended duration (if selected)

Primary CTA:
> Activate Protection

---

## 10. Motivational Reminders

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

## 11. Manual Reactivation Flow

- The user manually activates protection.
- Upon activation:
  - Blocking resumes
  - Progress tracking restarts
  - Accountability contact is notified

Example notification:
> “{Name} has turned protection back on in CleanMind.”

---

## 12. User Core Loop (Closed)

1. Protection OFF
2. User activates protection
3. Protection ON
4. User requests unlock (with friction)
5. Protection OFF
6. User manually reactivates protection
7. Loop repeats

---

## 13. Versioning

This document reflects CLOSED MVP behavior.
Any future changes must be logged in Development_Log.md.

## App Launch Flow (Updated)

1. App starts.
2. PlanState is loaded from local storage.
3. If ProtectionStatus == active:
   - Counter resumes from stored activatedAt.
4. If inactive:
   - HomeScreen displays activation state.
5. All state changes trigger automatic persistence.

