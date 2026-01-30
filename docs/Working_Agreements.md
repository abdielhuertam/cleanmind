# CleanMind — Working Agreements

This document defines how the CleanMind project is developed and how communication is handled.
Its purpose is to preserve context, avoid repeated explanations, and ensure consistency across sessions.

---

## 1. Project North Star

- The goal of CleanMind is defined in Product_Flow.md and related product documents.
- Code must always adapt to the product definition, never the opposite.
- If a conflict arises, product documentation takes priority.

---

## 2. Roles

- Abdiel:
  - Product owner and decision maker
  - Does not write code
  - Copies and pastes code exactly as provided
  - Validates behavior against product intent

- Assistant:
  - Designs architecture and writes code
  - Provides copy-paste ready instructions
  - Never assumes undocumented features
  - Never shifts scope without updating documentation

---

## 3. Communication Rules

- Instructions involving code must explicitly state one of:
  - REPLACE ENTIRE FILE
  - ADD WITHOUT DELETING
  - DELETE AND REPLACE A SPECIFIC SECTION (with exact location)

- Ambiguous instructions are not to be executed.
- If instructions are unclear, execution stops until clarified.

---

## 4. Development Rhythm

- Work is done in focused blocks (~1 hour).
- Each block has:
  - A clear objective
  - A verification step (“X working”)
  - A clear stopping point

- Commits are done only after a block is completed and verified.

---

## 5. Git Rules

- Git commits represent meaningful milestones, not partial work.
- Git is used visually via VS Code whenever possible.
- Reverting changes must always be possible without fear.

---

## 6. Session Resume Protocol

When resuming work after a break or a new conversation:

1. Read docs/Development_Log.md
2. Confirm Product_Flow.md remains valid
3. Continue from “Next Planned Block”
4. Do not re-interpret previous decisions

---

## 7. Context Preservation Principle

- If a rule, agreement, or decision is repeated more than once,
  it must be written into documentation.
- Documentation is the memory of the project, not the conversation history.

---

## 8. Change Management

- Product changes require updating Product_Flow.md.
- Process changes require updating this file.
- Code changes without documentation updates are considered incomplete.

---

## 9. Objective

The objective of these agreements is to ensure that:
- The original product vision is never lost
- Context survives across days and conversations
- Development remains calm, predictable, and intentional

## Canonical Project Documents (Source of Truth)

The following documents define the complete context, objectives, scope, and constraints of the CleanMind MVP.
These files collectively represent the single source of truth for the project.

They must be reviewed before resuming development after any pause or new session.

### Product & UX
- `docs/Product_Flow.md`  
  Defines user-facing behavior, states, flows, and restrictions.

- `docs/CleanMind_MVP_v1.0.md`  
  Defines product scope, target users, core principles, features included in the MVP, and out-of-scope items.

### Business Rules
- `docs/Business_Rules.md`  
  Defines Free vs Pro rules, unlock limitations, accountability constraints, counters, and enforcement logic.

### Technical Architecture
- `docs/Architecture.md`  
  Defines system responsibilities, offline-first approach, backend authority, and blocking engine strategy.

### Legal & Compliance
- `docs/Legal_Checklist.md`  
  Defines privacy, VPN disclosure, App Store / Play Store compliance, and legal requirements.

### Development State
- `docs/Development_Log.md`  
  Records completed work, current status, and next planned development blocks.

### Collaboration & Process
- `docs/Working_Agreements.md`  
  Defines communication rules, development rhythm, Git usage, and context preservation agreements.
