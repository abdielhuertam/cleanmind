# CleanMind — Product Flow (MVP)

This document defines the user-facing behavior of CleanMind for the MVP.
It describes what the user sees, what actions are available, and how the app behaves in each state.
This document is the operational source of truth for UI and product behavior.

---

## 1. Core Mental Model

- The default state of CleanMind is **PROTECTION ON**.
- Content blocking is considered permanent by default.
- Users do NOT freely enable or disable blocking.
- Users may only request **temporary UNLOCKS** under defined rules.
- When an unlock expires, protection is automatically re-enabled.

The app is designed to create intentional friction and accountability, not convenience.

---

## 2. Global App States (High Level)

CleanMind can be in one of the following global states at any time:

1. Protection ON (Normal State)
2. Temporary Unlock Active
3. VPN / Protection OFF (Error State)
4. Unlock Expired (Transition State)
5. Backend Unavailable (Restricted State)

Only one global state may be active at a time.

---

## 3. Home Screen — Default Entry Point

The Home Screen is the main and primary screen of the app.
All critical user actions start from this screen.

The Home Screen always displays:
- Current protection status
- Remaining unlock time (if applicable)
- Primary action button (contextual)
- Secondary information and guidance text

---

## 4. Home Screen States

### 4.1 State: Protection ON (Normal)

**Description**
- VPN is active
- Blocking is active
- No unlock is currently running

**Visual Indicators**
- Status label: “Protection ON”
- Status color: Green
- Short explanation text reinforcing protection

**Primary Action**
- Button: “Request Temporary Unlock”

**Secondary Information**
- Brief reminder about accountability and limits
- Link to view progress / medals (read-only)

**User Restrictions**
- User cannot disable protection directly
- User cannot access blocked content

---

### 4.2 State: Temporary Unlock Active

**Description**
- A temporary unlock has been granted
- Blocking is temporarily disabled
- A countdown timer is running

**Visual Indicators**
- Status label: “Temporary Unlock Active”
- Remaining time displayed (HH:MM)
- Status color: Amber / Orange

**Primary Action**
- No action to extend or cancel the unlock
- Unlock runs until expiration

**Secondary Information**
- Message reminding user that protection will resume automatically
- Optional notice if accountability partner was notified

**User Restrictions**
- User cannot extend unlock duration
- User cannot cancel unlock early
- User cannot request another unlock

---

### 4.3 State: Unlock Expired (Transition)

**Description**
- Unlock duration has ended
- Protection is being re-enabled automatically

**Visual Indicators**
- Temporary message: “Protection Restored”
- Short confirmation animation or message

**Behavior**
- Automatically transitions to “Protection ON”
- No user interaction required

---

### 4.4 State: VPN / Protection OFF (Error)

**Description**
- VPN or DNS protection is not active
- Blocking is not enforced

**Visual Indicators**
- Status label: “Protection OFF”
- Status color: Red
- Clear warning message

**Primary Action**
- Button: “Enable Protection”

**Secondary Information**
- Explanation that VPN is required for CleanMind to work
- Reassurance about privacy (no traffic inspection)

**User Restrictions**
- App functionality is limited
- Unlock actions are disabled until protection is restored

---

### 4.5 State: Backend Unavailable (Restricted)

**Description**
- Backend cannot be reached
- Local protection rules remain active

**Visual Indicators**
- Non-blocking warning message
- Protection status remains visible

**Behavior**
- Active unlocks continue if already granted
- New unlock requests are disabled

**User Restrictions**
- Cannot request new unlocks
- Cannot change plan-related settings

---

## 5. Unlock Request Flow

When the user taps “Request Temporary Unlock” from the Home Screen:

1. App presents available unlock methods:
   - Timed Text Copy
   - Accountability Code
   - Automatic Unlock (up to 8 hours)

2. User selects one method
3. App validates availability (plan limits, daily limits)
4. Backend validates the request
5. If approved:
   - Unlock begins
   - Timer starts
   - Notifications are sent as configured
6. If denied:
   - Clear explanation is shown
   - No retry loopholes are presented

---

## 6. Automatic Unlock Flow

- User selects duration (up to 8 hours)
- Duration cannot exceed maximum allowed
- Once started:
  - Unlock cannot be extended
  - Unlock cannot be canceled
- On expiration:
  - Protection is restored automatically
  - User is notified
  - Accountability partner is notified if enabled

---

## 7. Manual Unlock Flow

### 7.1 Timed Text Copy

- A motivational phrase is shown
- User must copy the text correctly within 30 seconds
- Failure results in unlock denial
- Success triggers unlock approval

---

### 7.2 Accountability Code

- User requests unlock code
- Code is sent externally (e.g., WhatsApp)
- Accountability partner receives:
  - Domain category (porn / social media)
  - Domain name (if applicable)
- User enters code to complete unlock

---

## 8. User Constraints (Intentional Friction)

Users CANNOT:
- Disable protection permanently
- Extend unlock duration
- Cancel an unlock early
- Bypass unlock limits
- Access blocked content without an unlock

These constraints are intentional and central to the product philosophy.

---

## 9. Notifications Behavior

Notifications may be sent for:
- Unlock granted
- Unlock expired
- Achievement milestones

Notification preferences are configurable, but critical alerts cannot be fully disabled.

---

## 10. Plan Awareness (Free vs Pro)

The Home Screen may display:
- Current plan (Free / Pro)
- Brief explanations when limits are reached

The app must never mislead users about available features.

---

## 11. Privacy & Transparency Requirements

At all times, the app must:
- Clearly indicate protection status
- Clearly disclose VPN usage
- Avoid deceptive UX patterns
- Avoid shame-based language

---

## 12. Versioning

- Document version: v1.0
- Any product flow changes require a new version
