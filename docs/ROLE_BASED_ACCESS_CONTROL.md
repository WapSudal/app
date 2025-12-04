# Project Architecture Guidelines: Role-Based Access Control (RBAC) in Flutter

**Tech Stack:** Flutter, Riverpod v3 (Annotation/Generator), GoRouter, Clean Architecture.

NOTE: The code example below is brief and illustrative. Adjust according to our actual project structure and coding standards.

## 1\. Directory Structure: Feature-First

Do not organize top-level folders by Role (e.g., `lib/doctor`, `lib/patient`). Organize by **Feature**. Handle roles inside the Presentation layer of each feature.

```text
lib/
├── core/                   # Global utilities, extensions, exceptions
├── features/
│   ├── auth/               # Authentication (Login, Role resolution)
│   ├── medical_record/     # Feature with mixed role logic
│   │   ├── data/           # Repositories, DTOs, Data Sources
│   │   ├── domain/         # Entities, UseCases (Role-agnostic)
│   │   └── presentation/   # MVVM Layer
│   │       ├── providers/  # Riverpod Notifiers (Logic)
│   │       ├── states/     # UI States (Freezed)
│   │       └── views/      # Widgets & Screens
│   └── prescription/       # Feature unique to one role (e.g., Doctor only)
└── main.dart
```

-----

## 2\. Implementation Strategies by Scenario

### Scenario A: Identical Features

  * **Context:** Logic and UI are the same for all roles (e.g., `Settings`, `ProfileView`).
  * **Strategy:** Standard MVVM implementation. No role checks required.

### Scenario B: Slight Variations (The Hybrid Approach)

  * **Context:** UI is 90% similar, but actions or visibility differ (e.g., Doctor can "Edit", Patient can only "View").
  * **Strategy:**
    1.  **Single ViewModel (Notifier):** Inject the `UserRole` into the Notifier.
    2.  **Smart State:** The State object should carry permission flags (e.g., `canEdit`, `showPrivateNotes`) derived from the role.
    3.  **Branching Logic:** Perform role checks inside the Notifier methods, not the View.

### Scenario C: Unique Features

  * **Context:** A page exists only for one role (e.g., `PrescriptionWriter` for Doctors).
  * **Strategy:** Create a dedicated Feature folder. Protect it via **Route Guards** in the Router configuration.

-----

## 3\. Navigation Guard (GoRouter)

For **Scenario C (Unique Features)**, protect routes using a redirection logic based on the role provider.

```dart
// core/router/app_router.dart
final routerProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(currentUserProvider);
  
  return GoRouter(
    routes: [
      GoRoute(
        path: '/doctor-dashboard',
        builder: (context, state) => const DoctorDashboardScreen(),
        redirect: (context, state) {
          // Guard: Only doctors can enter
          if (user?.role != UserRole.doctor) {
            return '/home';
          }
          return null;
        },
      ),
    ],
  );
});
```

-----