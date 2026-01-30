# CleanMind — Business Rules (MVP)

## 1. General Rules

- CleanMind operates using VPN/DNS-based content blocking.
- The VPN must be enabled for blocking to work.
- If VPN is disabled, the app must notify the user.

---

## 2. Blocking Rules

### 2.1 Pornographic Content
- Pornographic content is blocked by default when VPN is active.
- Blocking duration is unlimited for both Free and Pro users.
- Porn blocking cannot be permanently disabled in the Free plan.

### 2.2 Social Media
- Free plan:
  - User can block only **one** social media platform.
- Pro plan:
  - User can block **multiple** social media platforms.

---

## 3. Custom Blocked Sites

- Free plan:
  - Up to 5 custom domains.
- Pro plan:
  - Unlimited custom domains.

Domains are blocked by category, not by inspecting content manually.

---

## 4. Unlock Rules

### 4.1 Manual Unlocks

- Free plan:
  - Maximum of **1 manual unlock per day**.
- Pro plan:
  - Unlimited manual unlocks.

Manual unlock methods:
- Timed text copy (30 seconds)
- Accountability code

---

### 4.2 Automatic Unlock

- Available for both Free and Pro users.
- Maximum unlock duration: **8 hours**.
- After unlock expires, blocking is re-enabled automatically.

Notifications:
- User is always notified.
- Accountability partner is notified if enabled.

---

## 5. Accountability Partners

- Free plan:
  - Maximum of 1 accountability partner.
- Pro plan:
  - Up to 5 accountability partners OR one WhatsApp group.

The app does not read messages or access external conversations.

---

## 6. Progress Counters

- Separate counters are maintained for:
  - Pornography
  - Social media
- Counters reset when:
  - Manual unlock is performed
  - Automatic unlock is activated

Counters do not reset when VPN is temporarily disconnected unintentionally.

---

## 7. Achievements (Medals)

- Medals are awarded automatically.
- Medals cannot be deleted or reset.
- Medals reflect longest achieved streak.

---

## 8. Notifications

- Notifications are sent for:
  - Unlock events
  - Achievement milestones
- Users can configure notification preferences.

---

## 9. Subscription Rules

- Subscription status is verified via App Store / Play Store.
- If subscription expires:
  - User is downgraded to Free plan
  - Pro features are disabled immediately

---

## 10. Privacy Rules

- No human reviews browsing history.
- No storage of visited URLs.
- Only domain-level blocking data is processed.
- User data is never sold.

---

## 11. Error Handling

- If VPN connection fails:
  - User is notified
  - Blocking status is set to OFF
- App must clearly indicate protection status at all times.

---

## 12. Versioning

- This document: v1.0
- Any rule changes require a new version.

## Protection Interruption Rules

- Protection is activated explicitly by the user.
- Once active, protection cannot be freely disabled.
- Temporary unlocks are the only supported method to disable blocking.

If protection is interrupted unexpectedly (VPN off, app uninstall):
- The interruption may be logged
- The user may be notified
- Accountability partners may be notified if configured

For minors, CleanMind operates as a complementary layer to OS-level parental controls.

