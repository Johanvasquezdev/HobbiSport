# 🚀 HobbiSport

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-ready-orange?logo=firebase)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green)
![State Management](https://img.shields.io/badge/State%20Management-Bloc%2FCubit-purple)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 🏋️‍♂️ About

**HobbiSport** is a modern, community-driven mobile app designed to help users:

- Track hobbies 🎨
- Log sports activities 🏃
- Engage with a community 💬
- Manage personal events 📅

Built with **Flutter + Clean Architecture**, this project simulates a real production-ready app.

---

## ✨ Features

### 🎨 Hobbies

- Create, edit, delete hobbies
- Categorized content
- Personal descriptions

### 💬 Community

- Social feed
- Post system (likes & comments ready)

### 📅 Agenda

- Weekly calendar view
- Event scheduling
- Color-coded activities

### 🏃 Sports

- Activity tracking
- Stats (distance, duration)
- Session history

---

## 🎨 UI & Design

- 🌙 Dark mode first
- 🎯 Modern UI (Linear / Notion inspired)
- 🧩 Reusable components
- 🎛️ Multi-theme system

### Themes

| Theme  | Colors          |
| ------ | --------------- |
| Neon   | Coral + Cyan    |
| Sunset | Orange + Purple |
| Pop    | Lime + Pink     |

---

## 🧱 Architecture

This project follows **Clean Architecture**:

```plaintext
Presentation → Domain → Data
```

### Data Flow

```plaintext
UI → Cubit → UseCase → Repository → Datasource → Firebase
```

---

## 📂 Project Structure

```plaintext
lib/
├── core/
├── features/
│   ├── hobbies/
│   ├── community/
│   ├── agenda/
│   └── sports/
├── app.dart
├── main.dart
```

---

## 🌐 Backend

Prepared for:

- Firebase Firestore
- Firebase Authentication

Collections:

- hobbies
- posts
- events
- sports

---

## ⚙️ Getting Started

### 1. Clone repo

```bash
git clone https://github.com/your-username/hobbisport.git
cd hobbisport
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run app

```bash
flutter run
```

---

---

## 🔥 Roadmap

- [ ] Full Firebase integration
- [ ] Authentication system
- [ ] Real-time community feed
- [ ] Advanced sports analytics
- [ ] Notifications

---

## 📄 License

MIT License

---

## Authors

Johan Gabriel Vasquez

---

## ⭐ Support

If you like this project, give it a ⭐ on GitHub!
