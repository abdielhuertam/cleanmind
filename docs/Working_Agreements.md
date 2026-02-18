# CleanMind — Working Agreements

This document defines how the CleanMind project is developed and how communication is handled.
Its purpose is to preserve context, avoid repeated explanations, and ensure consistency across sessions.

---

## 1. Project North Star

* The goal of CleanMind is defined in Product_Flow.md and related product documents.
* Code must always adapt to the product definition, never the opposite.
* If a conflict arises, product documentation takes priority.

---

## 2. Roles

* Abdiel:

  * Product owner and decision maker
  * Does not write code
  * Copies and pastes code exactly as provided
  * Validates behavior against product intent

* Assistant:

  * Designs architecture and writes code
  * Provides copy-paste ready instructions
  * Never assumes undocumented features
  * Never shifts scope without updating documentation

---

## 3. Communication Rules

* Instructions involving code must explicitly state one of:

  * REPLACE ENTIRE FILE
  * ADD WITHOUT DELETING
  * DELETE AND REPLACE A SPECIFIC SECTION (with exact location)

* Ambiguous instructions are not to be executed.

* If instructions are unclear, execution stops until clarified.

---

## 4. Development Rhythm

* Work is done in focused blocks (~1 hour).

* Each block has:

  * A clear objective
  * A verification step (“X working”)
  * A clear stopping point

* Commits are done only after a block is completed and verified.

---

## 5. Git Rules

* Git commits represent meaningful milestones, not partial work.
* Git is used visually via VS Code whenever possible.
* Reverting changes must always be possible without fear.

---

## 6. Session Resume Protocol

When resuming work after a break or a new conversation:

1. Read docs/Development_Log.md
2. Confirm Product_Flow.md remains valid
3. Continue from “Next Planned Block”
4. Do not re-interpret previous decisions

---

## 7. Session Closure Protocol

When ending a development session that includes meaningful product or code changes:

1. Update `Development_Log.md` to record:

   * What was completed
   * What state the project is left in
   * What the next planned block is
2. Ensure documentation and code are aligned
3. Only then commit and push changes to Git

Closing a session without updating the Development Log is considered incomplete work.

---

## 8. Context Preservation Principle

* If a rule, agreement, or decision is repeated more than once,
  it must be written into documentation.
* Documentation is the memory of the project, not the conversation history.

---

## 9. Change Management

* Product changes require updating Product_Flow.md.
* Process changes require updating this file.
* Code changes without documentation updates are considered incomplete.

---

## 10. Objective

The objective of these agreements is to ensure that:

* The original product vision is never lost
* Context survives across days and conversations
* Development remains calm, predictable, and intentional

---

## 11. Delivery Tracking Protocol 🆕

To maintain clarity on timeline and execution rhythm:

1. At the end of each development session, the Assistant must explicitly state:

   * How many development blocks were completed in that session
   * The cumulative number of completed blocks relative to the estimated total
2. Block tracking must remain aligned with the current official delivery estimate.
3. If scope changes affect the timeline, the estimate must be recalculated and documented before continuing.

---

## 12. Time Estimation Standard 🆕

For planning and estimation purposes:

* One development week = 5 working days.
* Weekends are not assumed as development days unless explicitly agreed.
* A "block" represents approximately 1 focused hour of development work.
* Timeline projections must always clarify:

  * Blocks per day
  * Working days per week
  * Total estimated blocks remaining

This ensures that delivery expectations remain realistic and controlled.

---

## Canonical Project Documents (Source of Truth)

The following documents define the complete context, objectives, scope, and constraints of the CleanMind MVP.
They must be reviewed before resuming development after any pause or new session.

### Product & UX

* `docs/Product_Flow.md`

### Business Rules

* `docs/Business_Rules.md`

### Technical Architecture

* `docs/Architecture.md`

### Legal & Compliance

* `docs/Legal_Checklist.md`

### Development State

* `docs/Development_Log.md`

### Collaboration & Process

* `docs/Working_Agreements.md`

---

## AI Collaboration Protocol (Strict Mode)

This project requires strict continuity and architectural discipline.

The AI assistant must:

1. Never assume file structure or code state.
2. Always request the current version of a file before suggesting modifications.
3. Provide full file replacements when changes are required.
4. Clearly indicate when to run:

   * flutter run
   * flutter pub get
   * git commands
5. Never modify architecture without explicit justification.
6. Maintain strict alignment with previously agreed flows.
7. Avoid reintroducing discarded patterns or alternative architectures.
8. Respect MVP scope boundaries.
9. Prioritize stability over feature expansion.
10. Preserve business logic continuity across sessions.

Session Continuity Protocol:

When starting a new thread, the project state must be summarized as:

"Retomamos CleanMind.
Estado actual: persistencia implementada y funcional.
Siguiente objetivo: continuar flujo de desbloqueo."

The AI must treat the uploaded .md files as the single source of truth.
No deviations from documented agreements are allowed.

---

End of Protocol.
