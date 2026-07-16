# CleanMind — Business Rules (MVP)

This document defines the core business logic governing plan behavior,
unlock authorization, Support roles, and backend validation rules.

This file must remain aligned with Product_Flow.md, Architecture.md,
and the codebase.

---

## 1. Plan Types

CleanMind MVP supports two plans:

### Free Plan

Available protection modes:

- Permanent Protection
- Partial Protection

Partial Protection durations:

- 8 hours
- 12 hours
- 24 hours

Unlock methods:

- Fixed 8-hour Waiting Period
- Copy Challenge

Restrictions:

- No automatic SMS sending.
- No Support role available.
- No remote approval.

### Pro Plan

Available protection modes:

- Permanent Protection
- Partial Protection

Partial Protection durations:

- 1 hour
- 2 hours
- 3 hours
- 8 hours
- 12 hours
- 24 hours
- Custom date and time

Unlock methods:

- Configurable Waiting Period
- Accountability Code via SMS
- Optional Support approval

Backend validation is required for SMS and approval flows.

---

## 2. Protection States

Protection can be in one of the following states:

- inactive
- active
- deactivationPending (waiting period only)
- awaitingApproval (Support configured)
- protectionDisabled

State transitions must be deterministic and backend-validated where required.

---

## 3. Protection Modes

CleanMind supports two protection modes.

### Permanent Protection

Characteristics:

- No expiration date.
- Remains active until deactivation is requested.
- Generates full XP.
- Contributes to streak progression.
- Contributes to ranking progression.
- Eligible for medal milestones.

### Partial Protection

Characteristics:

- User selects a duration.
- Automatically disables when the selected duration expires.
- Generates reduced XP.
- Contributes to level progression.
- Does not contribute to medal milestones.
- Sends an expiration notification when protection ends.

---

## 4. Unlock Rules — Free Plan

When a Free user requests deactivation:

1. Protection remains ACTIVE.
2. An 8-hour waiting period is scheduled.
3. A countdown is displayed.
4. User may cancel at any time.
5. When the waiting period expires:
   - Protection transitions to protectionDisabled.
   - A local notification is delivered to the user.
   - Current streak resets.
   - Ranking progression may be affected.
   - Previously earned medals remain preserved.

No external notifications are sent.

---

## 5. Unlock Rules — Pro Plan (No Support Configured)

Available methods:

### Waiting Period

- Minimum duration: 1 hour.
- Automatically disables protection upon expiration.
- A local notification is delivered when the waiting period finishes.
- No automatic reactivation.

### Accountability Code (SMS-Based)

- A verification code is generated server-side.
- Code is stored securely in backend.
- Code expiration time is enforced.
- SMS is sent automatically via configured provider.
- Protection remains ACTIVE until valid code is entered.
- Upon successful validation:
  - Protection transitions to protectionDisabled.
  - Event is logged.

---

## 6. Unlock Rules — Pro Plan (Support Configured)

When a Support is configured:

- Waiting period is disabled.
- Copy Challenge is disabled.
- Unlock requires mandatory Support approval.
- Protection remains ACTIVE until approval is completed.

Two approval paths are supported.

---

### 6.1 Support With App Installed

- Unlock request is stored in backend.
- Support receives push notification.
- Support must authenticate (PIN or biometric).
- Support may Approve or Reject.
- All actions are logged.

If approved:
- User receives confirmation screen.
- User confirms final deactivation.
- Protection transitions to protectionDisabled.
- Event is recorded in Activity Log.

If rejected:
- Protection remains active.
- Event is recorded.

---

### 6.2 Support Without App (SMS Code)

- Backend generates a temporary verification code.
- Code expiration time is enforced.
- SMS is sent automatically.
- User must enter received code.
- Backend validates code.
- Protection transitions to protectionDisabled upon success.
- Event is logged.

---

## 7. Code Validation Rules

- All verification codes must be generated server-side.
- Codes must:
  - Be time-limited.
  - Be single-use.
  - Be invalidated upon success.
- Invalid attempts may be rate-limited.

---

## 8. Activity Logging

For Pro users with Support:

The system must record:

- Unlock request timestamp.
- Approval or rejection timestamp.
- Deactivation timestamp.
- Reactivation timestamp.
- Approval method (App or SMS).

Logs must be accessible to Support when using the app.

---

## 9. SMS Rules

- SMS must be sent only after explicit user confirmation.
- SMS must contain neutral, non-incriminatory language.
- SMS must not disclose specific content categories.
- Phone numbers must be stored securely.
- Delivery failures must be handled gracefully.

---

## 10. Reactivation Rules

- Protection can only be reactivated manually.
- Automatic reactivation is not supported.
- Reactivation events are logged.
- If Support is configured, reactivation is visible in history.

---

## 11. Motivational Reminders

- Reminders are optional.
- Reminders do not change protection state.
- Reminders must remain supportive and neutral.

---

## 12. Backend Requirements (MVP)

MVP requires:

- Authentication layer.
- Persistent backend storage.
- SMS provider integration.
- Push notification support.
- Secure state validation.

---

## 13. XP Rules

CleanMind uses an XP-based progression system.

### Permanent Protection

- Generates full XP.
- XP is earned hourly while protection remains active.
- Contributes to streak progression.
- Contributes to ranking progression.
- Contributes to medal progression.

### Partial Protection

- Generates reduced XP.
- XP is earned hourly while protection remains active.
- Contributes to level progression.
- Does not contribute to medal progression.

Exact XP values are configurable and may be adjusted in future releases without changing progression rules.

---

## 14. Medal Rules

Medals are awarded for consecutive protection streak milestones.

Current milestones:

- 7 Days
- 30 Days
- 90 Days
- 180 Days
- 365 Days

### 365+ Club

After reaching 365 consecutive days:

- The medal remains permanently visible.
- The streak counter continues increasing.
- Additional recognition may be added in future releases.

Previously earned medals are never removed.

---

## 15. Ranking Rules

The global ranking is ordered by:

1. Current streak
2. Total XP (tie breaker)

Ranking is designed to prioritize consistency while still rewarding long-term commitment.

If protection is deactivated:

- Current streak resets.
- Ranking position may be affected.
- Previously earned medals remain visible.

---

## 16. Streak Reset Rules

When protection is deactivated:

- Current streak resets.
- Current ranking progression may be affected.

The following are preserved:

- Historical achievements
- Earned medals
- User profile
- Activity history

Protection must be manually reactivated through the Protection Mode Selection flow.

---

## 17. Versioning

This document reflects CLOSED MVP behavior including:

- Backend validation
- SMS-based verification
- Support approval logic

All future changes must be logged in Development_Log.md.