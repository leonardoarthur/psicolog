# PsicoLog 🧠✨

**PsicoLog** is a modern, privacy-focused mental health companion app built with Flutter. It mimics a digital sanctuary where users can record their dreams, daily insights, and emotions in a secure, local-first environment.

Designed with a premium "Glassmorphism" aesthetic, it prioritizes user experience through fluid animations and a calming interface.

---

## 🚀 Key Features

### 1. Diário (Journal) 📔
The core of PsicoLog. Users can create different types of entries:
- **Dreams**: Record sleep experiences with specific tags (e.g., #Lucid, #Nightmare) and "Wake Up Mood".
- **Insights**: Capture sudden realizations or ideas.
- **Emotions**: Track emotional intensity (1-5) and context.
- **Privacy**: All data is stored locally using **Isar Database**, ensuring your thoughts remain yours.

### 2. Catarse (Catharsis) 🌬️
A unique feature designed to help users "let go" of intrusive thoughts.
- Users type their worries or stressors.
- Upon releasing, the text visually "evaporates" (using complex animations), symbolizing the act of letting go.
- **Ephemeral**: These entries are *not* saved to the database, reinforcing the concept of release.

### 3. Sonhos (Dream Journal) 🌙
A dedicated view for your dream patterns.
- Visualize frequency of dreams.
- Filter by tags.
- Analyze "Dream Associations" and identify recurring symbols.

### 4. Ecos (Echoes) 🔊
(Feature in development)
- Analyzes patterns in your journaling.
- Provides feedback or "echoes" of your own thoughts to help with self-reflection.

### 5. Mood Heatmap 📅
- A Github-style contribution graph for your emotions.
- Visualize low and high energy days at a glance.

---

## 🛠️ Technology Stack

This project leverages modern Flutter capabilities and packages:

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [Provider](https://pub.dev/packages/provider) for clean, scoped state access.
- **Database**: [Isar](https://isar.dev) - Extremely fast, ACID-compliant local database.
- **UI/Animations**:
    - [flutter_animate](https://pub.dev/packages/flutter_animate) for declarative animations.
    - [flutter_heatmap_calendar](https://pub.dev/packages/flutter_heatmap_calendar) for the mood tracker.
    - [google_fonts](https://pub.dev/packages/google_fonts) for typography.
- **Utilities**: `intl`, `path_provider`.

---

## 📂 Project Structure

The project follows a clean architecture pattern:

```
lib/
├── data/           # Data layer
│   └── models/     # Isar entities (Entry, Dream, etc.)
├── logic/          # Business logic
│   └── providers/  # State management (JournalProvider, etc.)
├── ui/             # Presentation layer
│   ├── screens/    # Full page widgets (Journal, Catharsis, Home)
│   ├── widgets/    # Reusable components (EntryCard, EntryForm)
│   └── app_theme.dart # centralized theme configuration
└── utils/          # Helpers and extensions
```

## ⚡ Getting Started

### Prerequisites
- Flutter SDK (3.10+)
- Dart SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/psicolog.git
   cd psicolog
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Code Generation (for Isar)**
   Since we use Isar, you need to generate the adapter code:
   ```bash
   dart run build_runner build
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

---

## 🎨 Design Philosophy

PsicoLog uses a **Dark/Glass** aesthetic:
- **Colors**: Deep purples, teals, and dark greys (`Colors.grey.shade900`, `Colors.deepPurple`).
- **Typography**: Clean, sans-serif fonts for readability.
- **Motion**: Everything should feel "alive" but not overwhelming. Lists cascade in, buttons pulse gently, and interactions have immediate feedback.

---

*Verified locally on Linux/Android.*
