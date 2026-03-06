# Synq — Project Report

**Title:** Synq — Social Trends Aggregator

**Authors:**

- Hamza — Backend, Database, Firestore rules, Admin services, Report generation, overall implementation
- Ali — Frontend design, UI/UX, color scheme, admin UX ideas

**Affiliation:** Personal/University Project
**Date:** January 14, 2026
**Version:** 1.0

---

## Abstract

Synq is a Flutter-based mobile application that aggregates trends (videos, news, topics) and enables user interaction through posts, comments, likes, and reporting. This report summarizes architecture, database design, admin capabilities, security rules, implementation details, testing, and future work.

## Table of Contents

- Introduction
- Objectives
- Technical Stack
- Architecture
- Database Design
- Key Features & Implementation
- Security & Rules

# Synq — Project Report

**Title:** Synq — Social Trends Aggregator

**Authors:**

- Hamza — Lead Backend Engineer, Database Architect, Firestore Rules & Admin Services, Documentation and Deployment
- Ali — Lead Frontend Designer, UI/UX, Visual Design, Admin UX

**Affiliation:** Personal/University Project
**Date:** January 14, 2026
**Version:** 1.1

---

## Abstract

Synq is a Flutter mobile application designed to aggregate trending content (videos, news, and topical items) and provide a lightweight platform for users to engage with that content via posts, comments, likes, and reports. This document details the system architecture, database design, security considerations, implementation highlights, testing outcomes, and contributions from both team members.

## Table of Contents

- Introduction
- Objectives
- Technical Stack
- Architecture
- Database Design
- Key Features & Implementation
- Security & Rules
- Testing & QA
- Deployment & Operations
- Future Work
- Contributions
- Appendices

## Introduction

Problem: Create a mobile-first, real-time application that surfaces trending content from multiple sources while providing robust moderation and user engagement features.

Scope: Cross-platform mobile app built with Flutter, backed by Firebase Authentication and Cloud Firestore for persistence and real-time updates.

## Objectives

- Aggregate trends from external sources and present them in an engaging feed.
- Provide user-generated content features: posting, commenting, liking, and reporting.
- Provide admin/moderation tools to manage content and users securely.

## Technical Stack

- Frontend: Flutter (Dart) with Provider for state management
- Backend: Firebase Auth and Cloud Firestore
- Tooling: Firebase CLI for rules deploys, Python + ReportLab for documentation generation

## Architecture

The app uses a service/repository layer for Firestore interactions, Provider for auth and app state, and modular feature folders separating admin, auth, home, posts, and reports. Admin-only responsibilities are encapsulated in `AdminService` and `AdminRepository` to centralize permission-sensitive operations.

## Database Design

See the ER diagram (`assets/db_diagram.png`). Primary collections and design notes:

- `users`: Stores profile, `isAdmin` flag (short-term), `banned` flag, role metadata. Primary lookup by `uid`.
- `trends`: Aggregated trend items (YouTube/video, news, topics) with metadata and engagement counters.
- `posts`: User-created posts referencing `userId`.
- `comments`: Sub-collection under `posts/{postId}/comments` to efficiently fetch comments for a post.
- `likes`: Polymorphic collection storing likes for `post`, `comment`, or `trend` with `targetType/targetId`.
- `reports`: User-submitted reports with type, description, and status for moderation workflow.
- `admin_actions`: Records admin operations (promote/demote, ban, delete) to provide lightweight history.
- `audit_logs`: Verbose audit entries including before/after payloads for compliance and rollback reference.

Indexing: Composite and single-field indexes were planned for feed pagination and analytics queries (e.g., `createdAt` desc, `likes` desc).

## Key Features & Implementation

- Authentication: Firebase Auth drives session and `users/{uid}` creation. Basic profile fields are stored at sign-up.
- Admin Flow: Admin UI screens (`AdminDashboard`, `UserManagement`) let authorized users promote, ban, purge old trends, and review reports.
- Trend Sync: Admin-initiated batch sync utilities transform external API responses into normalized `trends` documents.
- Post/Comment/Like: Real-time listeners and transactions increment counters atomically for likes. Likes are stored in `likes` collection for auditability.

## Security & Rules

Short-term approach uses `users/{uid}.isAdmin` in Firestore checked by security rules for admin-restricted writes. The report includes a recommendation to migrate to Firebase Custom Claims (`request.auth.token.admin == true`) using the Admin SDK for production environments.

## Testing & QA

- Device testing on Android (multiple runs via `flutter run`) revealed UI overflows and Firestore permission edge cases which were fixed.
- Resiliency: Admin actions are wrapped in try/catch to surface errors to moderators and to avoid crash loops when network or permission failures occur.
- Known constraints: Device DNS/connectivity can block Firestore operations; testing should be performed on a stable network.

## Deployment & Operations

- Firestore rules deployment using Firebase CLI is included in the operational checklist. Backups via scheduled exports to Cloud Storage are recommended.
- For production: enable custom claims, tighten App Check, and add monitoring and alerting on rule failures and quota issues.

## Future Work

- Migrate `isAdmin` to Custom Claims and update rules to use `request.auth.token.admin`.
- Enforce `banned` at auth or sign-in level to prevent banned users from accessing the app.
- Add scheduled cloud functions to purge old trends and to compact audit logs into archival storage.

## Contributions (Detailed)

### Hamza (Lead Backend Engineer & Project Lead)

- Architected the data model and wrote the security rules that enforce admin-only operations, including the short-term `isAdmin` checks and guidance for secure migration to custom claims.
- Implemented server-side like counters, transactions for content integrity, and batch utilities used for trend sync and purging aged trends.
- Built `AdminService`, user management screens, and implemented end-to-end admin flows including promote/demote, ban/unban, and content deletion.
- Wrote the project documentation pipeline (Markdown → PDF), created the ER diagram generator, and prepared deliverables for submission.
- Led debugging sessions for permission-denied issues, fixed rendering/layout problems in coordination with Ali, and coordinated test runs on Android devices.

### Ali (Lead Frontend Designer & UX)

- Designed the app's visual identity: color palette, iconography, consistent paddings and spacing, and responsive component behavior that make the interface accessible and visually coherent.
- Delivered UI prototypes and high-fidelity mockups for the trends feed, post composer, comment threading, and admin dashboards; worked closely with Hamza to ensure API responses matched frontend expectations.
- Focused on admin UX: created streamlined workflows for reviewing reports, quick action menus for moderators, and in-context feedback (SnackBars, confirmation dialogs) to reduce moderator errors.
- Performed cross-device visual QA, provided accessibility adjustments (contrast, touch target sizes), and recommended animation timing to improve perceived performance.

### Teamwork Highlights

- Hamza and Ali practiced an efficient division of labor: Hamza tackled the data integrity, rules, and services while Ali iterated on UI and usability.
- Both members pair-debugged critical flows, and Ali's visual guidance helped Hamza prioritize UX fixes during backend changes.

---

## Appendices

- Database design PDF: `DATABASE_DESIGN.pdf`
- ER Diagram: `assets/db_diagram.png`

---

_Prepared by Hamza and Ali._
