# HobbiSport Architecture

## Overview
HobbiSport is a Flutter mobile app for tracking hobbies, sports activities, community posts, and personal events.

The app follows Clean Architecture and is designed to be scalable and production-ready.

---

## Tech Stack
- Flutter (Material 3)
- State Management: Cubit (Bloc)
- Backend: Firebase (Firestore + Auth ready)
- Dependency Injection: GetIt

---

## Architecture Pattern

The app follows Clean Architecture:

presentation → domain → data

### Layers:

#### 1. Presentation
- UI (screens, widgets)
- Cubits (state management)

#### 2. Domain
- Entities
- Repository interfaces
- Use cases

#### 3. Data
- Models
- Datasources (Firebase)
- Repository implementations

---

## Folder Structure

lib/
- core/
  - theme/
  - network/
  - services/
  - error/
  - utils/
  - widgets/

- features/
  - hobbies/
  - community/
  - agenda/
  - sports/

Each feature contains:
- data/
- domain/
- presentation/

- shared/
- injection_container.dart
- app.dart
- main.dart

---

## Features

### Hobbies
- CRUD operations
- Fields: id, name, category, description

### Community
- Posts feed
- Fields: id, user, content, timestamp, likes, comments

### Agenda
- Events scheduling
- Fields: id, title, datetime, location, category

### Sports
- Activity tracking
- Fields: id, type, date, stats

---

## Backend

Using Firebase Firestore collections:
- hobbies
- posts
- events
- sports

---

## UI Design

- Dark mode first
- Modern, vibrant design
- Rounded cards
- Soft shadows

### Themes

1. Neon
2. Sunset
3. Pop

Themes must be dynamic and switchable.

---

## Rules (CRITICAL)

- DO NOT change architecture
- DO NOT mix layers
- UI must not contain business logic
- Domain must be pure (no Flutter imports)
- Data layer handles Firebase

---

## Data Flow

UI → Cubit → UseCase → Repository → Datasource → Firebase