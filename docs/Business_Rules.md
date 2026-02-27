# CleanMind — Business Rules (MVP)

This document defines the core business logic governing plan behavior,
unlock authorization, Support roles, and backend validation rules.

This file must remain aligned with Product_Flow.md, Architecture.md,
and the codebase.

---

## 1. Plan Types

CleanMind MVP supports two plans:

### Free Plan
- Fixed 8-hour waiting period required for full deactivation.
- Copy Challenge available.
- No automatic SMS sending.
- No Support role available.
- No remote approval.

### Pro Plan
- Configurable waiting period (minimum 1 hour) when no Support is configured.
- Accountability Code via automatic SMS.
- Optional Support role.
- Backend validation required for SMS and approval flows.

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

## 3. Unlock Rules — Free Plan

When a Free user requests deactivation:

1. Protection remains ACTIVE.
2. An 8-hour waiting period is scheduled.
3. A countdown is displayed.
4. User may cancel at any time.
5. When the waiting period expires:
   - Protection transitions to protectionDisabled.
   - Progress resets.

No external notifications are sent.

---

## 4. Unlock Rules — Pro Plan (No Support Configured)

Available methods:

### Waiting Period
- Minimum duration: 1 hour.
- Automatically disables protection upon expiration.
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

## 5. Unlock Rules — Pro Plan (Support Configured)

When a Support is configured:

- Waiting period is disabled.
- Copy Challenge is disabled.
- Unlock requires mandatory Support approval.
- Protection remains ACTIVE until approval is completed.

Two approval paths are supported.

---

### 5.1 Support With App Installed

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

### 5.2 Support Without App (SMS Code)

- Backend generates a temporary verification code.
- Code expiration time is enforced.
- SMS is sent automatically.
- User must enter received code.
- Backend validates code.
- Protection transitions to protectionDisabled upon success.
- Event is logged.

---

## 6. Code Validation Rules

- All verification codes must be generated server-side.
- Codes must:
  - Be time-limited.
  - Be single-use.
  - Be invalidated upon success.
- Invalid attempts may be rate-limited.

---

## 7. Activity Logging

For Pro users with Support:

The system must record:

- Unlock request timestamp.
- Approval or rejection timestamp.
- Deactivation timestamp.
- Reactivation timestamp.
- Approval method (App or SMS).

Logs must be accessible to Support when using the app.

---

## 8. SMS Rules

- SMS must be sent only after explicit user confirmation.
- SMS must contain neutral, non-incriminatory language.
- SMS must not disclose specific content categories.
- Phone numbers must be stored securely.
- Delivery failures must be handled gracefully.

---

## 9. Reactivation Rules

- Protection can only be reactivated manually.
- Automatic reactivation is not supported.
- Reactivation events are logged.
- If Support is configured, reactivation is visible in history.

---

## 10. Motivational Reminders

- Reminders are optional.
- Reminders do not change protection state.
- Reminders must remain supportive and neutral.

---

## 11. Backend Requirements (MVP)

MVP requires:

- Authentication layer.
- Persistent backend storage.
- SMS provider integration.
- Push notification support.
- Secure state validation.

---

## 12. Versioning

This document reflects CLOSED MVP behavior including:

- Backend validation
- SMS-based verification
- Support approval logic

All future changes must be logged in Development_Log.md.