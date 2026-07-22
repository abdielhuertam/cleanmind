# CleanMind — Product Flow (MVP)

This document describes the end-to-end user experience and core interaction loops
of the CleanMind mobile application.

This file reflects CLOSED product decisions and must stay aligned with
Business_Rules.md and the codebase.

---

## 1. First Launch & Language Selection

- On first launch, CleanMind detects the device language automatically.
- If the detected language is supported, it is preselected for the user.
- If the detected language is not supported, English is selected by default.
- If the device language is not supported, English is selected automatically.

Supported languages (MVP):

- English
- Spanish
- French
- Portuguese

The user is presented with a language selection screen where they may:

- Keep the detected language
- Select a different supported language

The selected language:

- Is stored locally
- Applies to all UI copy and motivational messages
- Applies to onboarding and notifications
- Can be changed later from Settings

Language selection occurs only during first launch unless changed manually by the user.
---

## 2. Initial State (Protection Inactive)

- The app always starts with protection **OFF**.
- No blocking is applied until the user activates protection.
- No XP is generated.
- No streak is active.
- No protection timer is running.

Primary CTA:
> Choose Protection Mode

---

## 3. Protection Mode Selection

When the user chooses to activate protection, CleanMind presents two protection modes.

### Permanent Protection

Characteristics:

- No expiration date.
- Protection remains active until the user requests deactivation.
- Generates full XP.
- Contributes to streak progression.
- Contributes to level progression.
- Contributes to ranking progression.
- Eligible for milestone medals.

Protection can only be disabled through the available unlock methods based on the user's plan and Support configuration.

### Partial Protection

Characteristics:

- User selects a predefined duration or custom duration.
- Protection automatically disables when the selected duration expires.
- Generates reduced XP.
- Does not contribute to medal progression.
- Sends an expiration notification when protection ends automatically.

### Free Plan

Available durations:

- 8 hours
- 12 hours
- 24 hours

### Pro Plan

Available durations:

- 1 hour
- 2 hours
- 3 hours
- 8 hours
- 12 hours
- 24 hours
- Custom date and time

---

## 4. Protection Active State

When protection is active:

- Content blocking is enforced.
- XP is generated while protection remains active.
- The Home screen clearly displays:
  - Protection status: ON
  - Current streak
  - Current level
  - XP progress

Primary actions:

- Request Temporary Unlock
- View Progress

Additional MVP UX behavior:

- Home screen prioritizes progress visibility.
- Home screen functions primarily as a dashboard/status view.
- A notification bell provides fast access to Pending Requests.
- Pending unlock requests display an active countdown banner.
- Protection actions are centralized inside the Protection screen.

Users may manually add custom blocked websites/domains.

Blocked sites remain visible regardless of protection state.

While protection is ACTIVE:

- blocked sites cannot be edited
- blocked sites cannot be deleted

While protection is DISABLED:

- blocked sites may be edited
- blocked sites may be removed

### Permanent Protection

While Permanent Protection is active:

- Full XP is generated.
- Streak progression is active.
- Ranking progression is active.
- Medal milestones may be earned.

### Partial Protection

While Partial Protection is active:

- Reduced XP is generated.
- Protection remains active until the selected duration expires.
- Protection automatically disables when the selected duration ends.
- Medal progression is not awarded.
- The remaining protection time is displayed in both:
  - Home dashboard
  - Protection screen
- A countdown is visible while Partial Protection is active.
- When the countdown reaches zero:
  - Protection automatically transitions to the Disabled state
  - An expiration notification is sent (implementation pending)
---

## 5. Request Temporary Unlock — Entry Point

When the user taps **Request Temporary Unlock**:

1. The app displays a clear warning:
   > “If you continue, your progress counter will reset.”

2. The user must explicitly confirm to proceed.

3. The user is presented with the available unlock methods
   based on their current plan and Support configuration.

---

## 6. Unlock Methods Overview

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
- A local notification is sent automatically when protection expires.

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

## 7. Accountability Code Flow (Pro — No Support or SMS-Based Support)

1. User selects **Accountability Code** from the available unlock methods.
2. The SMS Code screen is displayed showing the configured accountability phone number.
3. The user presses **Send Code**.
4. A confirmation dialog explains the consequences of disabling protection.
5. After confirmation:
   - The verification code is requested.
   - The SMS is sent.
   - The code entry fields become enabled.
6. The user enters the received verification code.
7. The verification code is validated.

Outcomes:

- Correct code → Protection disabled
- Incorrect or expired code → Protection remains active

Notes:

- Verification codes are generated server-side.
- Codes expire after a defined time window.
- CleanMind does not read incoming messages.
- SMS sending always requires explicit user confirmation before being requested.

---

## 8. Support Approval Flow (Pro — Support Configured)

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

## 9. Protection Disabled State

When protection is disabled:

- Blocking is fully off.
- XP generation stops.
- The Home screen displays:
  - Protection status: OFF
  - Time since deactivation

Additional disabled-state behavior:

- Users may modify custom blocked sites.
- Users may remove previously blocked sites.
- Protection remains fully manual and does not reactivate automatically.

Whenever protection is disabled immediately (for example through Copy Challenge or SMS Code):

- The app displays a temporary **Protection Disabled** confirmation overlay.
- The overlay automatically disappears after approximately 3 seconds.
- The user is then returned to the Protection screen.

If protection is still pending external approval (Support Push Approval), no disabled confirmation is shown because protection remains active until approval is completed.

If protection was disabled from Permanent Protection mode:

- Current streak resets.
- Ranking progression may be affected.
- Previously earned medals remain visible in the user's profile.
- Historical achievements are preserved.

If protection was disabled from Partial Protection mode:

- XP earned during the completed protection period is preserved.
- No medal progression is awarded.

Primary CTA:

> Choose Protection Mode

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

- The user manually chooses to reactivate protection.
- CleanMind presents the Protection Mode Selection screen.

Available options:

1. Permanent Protection
2. Partial Protection

If Permanent Protection is selected:

- Blocking resumes immediately.
- Full XP generation begins.
- Streak progression resumes.
- Ranking progression resumes.

If Partial Protection is selected:

- User selects a duration.
- Blocking resumes immediately.
- Reduced XP generation begins.
- Protection automatically disables when the selected duration expires.

Immediately after activation:

- The app displays a temporary **Protection Activated** confirmation overlay.
- The overlay automatically disappears after approximately 3 seconds.
- After activation, the application always returns the user to the **Protection** tab, regardless of where the activation flow was started.

If Support is configured:

- Reactivation events may be recorded in history.

---

## 12. User Core Loop (Updated)

### Permanent Protection Loop

1. Protection OFF
2. User selects Permanent Protection
3. Protection ON
4. XP is generated at the full rate
5. Streak progression advances
6. Medal milestones may be earned
7. Ranking progression advances
8. User requests unlock
9. Protection OFF
10. Current streak resets
11. User manually selects a protection mode again

---

### Partial Protection Loop

1. Protection OFF
2. User selects Partial Protection
3. User selects a duration
4. Protection ON
5. XP is generated at a reduced rate
6. Protection remains active until expiration
7. Protection automatically disables
8. Expiration notification is sent (implementation pending)
9. Protection OFF
10. User manually selects a protection mode again

---

### Free Plan

1. Protection OFF
2. User selects:
   - Permanent Protection
   - Partial Protection (8h, 12h, 24h)
3. Protection ON
4. User requests unlock
5. Copy Challenge (confirmation is requested only after the challenge is completed successfully)
6. Protection OFF
7. User manually selects a protection mode again

---

### Pro Plan (No Support)

1. Protection OFF
2. User selects:
   - Permanent Protection
   - Partial Protection
3. Protection ON
4. User requests unlock
5. Waiting Period or SMS Code verification
6. Protection OFF
7. User manually selects a protection mode again

---

### Pro Plan (Support Configured)

1. Protection OFF
2. User selects:
   - Permanent Protection
   - Partial Protection
3. Protection ON
4. User requests unlock
5. Support approval required
6. Protection OFF only after approval
7. User manually selects a protection mode again

---

## 13. Progression System (MVP Foundation)

CleanMind includes a progression system designed to reward consistency and intentional focus.

### XP Generation

- XP is earned while protection is active.
- XP values may vary between Permanent Protection and Partial Protection.
- Exact XP values are configurable and may be adjusted in future releases without changing progression rules.

### Permanent Protection

- Generates full XP.
- XP is accumulated hourly.
- Contributes to streak progression.
- Contributes to ranking progression.
- Eligible for medal milestones.

### Partial Protection

- Generates reduced XP.
- XP is accumulated hourly.
- Contributes to level progression.
- Does not contribute to medal milestones.

### Medal Milestones

Users may earn milestone medals for maintaining consecutive protection streaks.

Current milestones:

- 7 Days
- 30 Days
- 90 Days
- 180 Days
- 365 Days

### 365+ Club

After reaching 365 consecutive days:

- The medal remains visible permanently.
- The streak counter continues increasing.
- Additional recognition may be added in future releases.

### Historical Achievements

Previously earned medals are never removed.

If protection is deactivated:

- Current streak resets.
- Ranking progression may be affected.
- Previously earned medals remain visible in the user's profile.

### Ranking

The global ranking is ordered by:

1. Current streak
2. Total XP (used as a tie breaker)

This approach prioritizes consistency while still rewarding long-term commitment.

### Future Community Integration

The progression system is designed to support future community features including:

- User profiles
- Levels
- Rankings
- Activity feeds
- Achievement visibility
- Social interactions

---

## 14. Versioning

This document reflects CLOSED MVP behavior including backend-based approval and SMS verification.

Any future changes must be logged in Development_Log.md.

## Android Enforcement Behavior (MVP Addition)

On Android devices:

- CleanMind monitors foreground applications using AccessibilityService.
- If a blocked application is opened:
  - CleanMind interrupts access
  - User is automatically returned to the launcher/home screen

Current enforcement behavior is interruption-based only.

Future planned behavior includes:

- intentional pause overlays
- breathing delays
- countdown friction
- unlock confirmation UX

---

## 13. Protection Status Feedback

CleanMind provides immediate visual feedback whenever the protection state changes.

### Protection Activated

Displayed after:

- Permanent Protection activation.
- Partial Protection activation (Free).
- Partial Protection activation (Pro).
- Partial Protection activation (Custom).

Behavior:

- Green shield icon.
- "Protection Activated".
- Automatically disappears after approximately 3 seconds.

### Protection Disabled

Displayed after:

- Copy Challenge.
- SMS Code verification.

Behavior:

- Gray shield icon.
- "Protection Disabled".
- Automatically disappears after approximately 3 seconds.

### Pending Approval

Support approval requests do not display a disabled confirmation because protection remains active until approval is received.

### Settings

The Settings section is organized into four categories:

- Account Settings
- Protection Settings
- About CleanMind
- Progress Notifications

### Protection Settings

Protection Settings only contains protection-related configuration:

Protection
- Blocked Apps
- Custom Blocked Sites

Accountability
- Support

Notification preferences are no longer managed from this screen.

### Progress Notifications

Progress notifications have been moved to their own dedicated screen.

Available options:

- Milestone Celebrations
- Level Up Notifications
- Recurring Progress Reminder (PRO)
- Reminder Interval (PRO)

Current implementation is UI-only. Preference persistence and notification scheduling will be implemented in a future development phase.

Progress Notifications

- Milestone Celebrations
- Level Up Notifications
- Recurring Progress Reminder (PRO)
- Reminder Interval (1–30 days)

Behavior

- Changes are applied immediately.
- Changes are automatically saved.
- Preferences persist after app restart.
- Each option is independent and does not modify other notification settings.

Recurring Progress Reminder

- Available for PRO users.
- User can enable or disable reminders.
- User selects reminder interval.
- Reminder is automatically rescheduled whenever the interval changes.