# CleanMind — Legal & Compliance Checklist (MVP)

This document defines the minimum legal, privacy, and compliance requirements
required to publish CleanMind on the Apple App Store and Google Play Store.

This file is cumulative and must not remove historical or required sections.
New requirements must be appended, not replaced.

---

## 1. Privacy Policy (REQUIRED)

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

The Privacy Policy must clearly state:

### Data Collected
- Email address (if registration is enabled)
- User ID
- Subscription status
- Protection state
- Progress counters
- App preferences
- Language selection
- Support phone number (if configured)
- Unlock request timestamps
- Approval or rejection timestamps

### Data NOT Collected
- Browsing history
- Full URLs
- Website content
- Message content
- Contact lists
- Personal conversations

### Data Usage
- App functionality
- Progress tracking
- Subscription validation
- Unlock verification
- Support approval workflow
- Optional notifications

### Data Sharing
- No selling of user data
- No advertising data sharing
- SMS provider used strictly for verification delivery
- No third-party analytics that inspect browsing traffic

### Data Storage
- Secure storage
- Minimal retention
- User-initiated deletion
- Verification codes must expire automatically

---

## 2. Terms & Conditions (REQUIRED)

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

Must include:
- Description of the service
- User responsibilities
- Acceptable use
- Subscription terms
- Limitation of liability
- Availability disclaimer
- Termination conditions
- Explanation of Support approval mechanism (Pro)

---

## 3. VPN / DNS Usage Disclosure (CRITICAL)

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

CleanMind must clearly disclose:

- That the app uses VPN/DNS technology
- That the VPN is used exclusively for content blocking
- That no traffic is inspected
- That no browsing activity is logged

This disclosure must appear:
- In App Store / Play Store listings
- In the Privacy Policy
- In the in-app onboarding

---

## 4. Apple App Store Compliance

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

Requirements:
- VPN usage justification
- Privacy Nutrition Labels completed
- Sign in with Apple (if third-party login exists)
- Clear subscription explanation
- No deceptive behavior
- No dark patterns
- Disclosure of automated SMS sending (if applicable)

---

## 5. Google Play Compliance

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

Requirements:
- Data Safety section completed
- VPN permission properly explained
- Transparent subscription details
- Refund policy disclosure
- No misleading claims
- Disclosure of automated SMS sending (if applicable)

---

## 6. Subscriptions & Billing

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

- Subscriptions handled only via:
  - Apple App Store
  - Google Play Store
- No external payment links
- Clear renewal terms
- Easy access to manage subscriptions

---

## 7. Notifications Consent

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

- Explicit user consent required
- Clear explanation of notification types:
  - Motivational reminders
  - Support approval requests
  - Unlock confirmations
- Notifications must be optional and configurable

---

## 8. Accountability Messaging (UPDATED)

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

- Accountability messages are generic and non-sensitive
- Messages do NOT disclose:
  - Content categories
  - Pornography
  - Specific websites or apps
- Messages may be sent automatically via SMS (Pro)
- SMS sending requires explicit in-app confirmation
- CleanMind does NOT:
  - Read incoming messages
  - Access chats
  - Store message content

---

## 9. SMS Automation (NEW)

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

- SMS messages are sent via a secure backend provider
- SMS content must remain neutral and non-incriminatory
- Phone numbers must be stored securely
- SMS sending must occur only after explicit user action
- Verification codes must:
  - Be time-limited
  - Be single-use
  - Expire automatically

---

## 10. Support Role & Parental Approval (NEW)

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

When a Support contact is configured:

- Support approval may be required before protection is disabled
- Support may authenticate via app (PIN or biometric)
- Approval or rejection events must be logged
- Logs must not contain browsing data
- Support approval workflow must be clearly explained in Terms & Privacy Policy

---

## 11. Motivational Notifications (MVP ADDITION)

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

- Motivational reminders are optional
- User-selectable intervals:
  - 1 hour
  - 3 hours
  - 12 hours
  - 24 hours
- Notifications are supportive and non-judgmental
- Notifications do not change protection state

---

## 12. Child & Family Usage (UPDATED)

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

- App may be used by minors under parental supervision
- Parents are responsible for configuration
- Support approval system may be used for parental oversight
- No browsing history is collected
- No explicit content is displayed

COPPA, GDPR-K, and local minor protection regulations must be reviewed prior to launch.

---

## 13. Data Deletion & Account Removal

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

Users must be able to:
- Request account deletion
- Remove stored data
- Remove Support relationship

Deletion must:
- Be documented
- Be enforced in backend systems

---

## 14. Legal Hosting

Status: ⬜ Not started / ⬜ In progress / ⬜ Completed

- Privacy Policy must be publicly accessible
- Terms & Conditions must be publicly accessible
- Hosted domain:
  - cleanmindblocker.com (tentative)

---

## 15. Versioning

- This document is cumulative
- Sections must not be removed
- Updates must append new requirements
- Review required before store submission