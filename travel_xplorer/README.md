# Travel Xplorer - Travel Planner (Flutter Web)

A responsive, multi-screen Travel Planner built with Flutter. Browse destinations,
save favourites, create trips with a validated form, build a day-by-day itinerary
and track your budget.

## Run it

```bash
# 1. In this folder, generate the platform folders (web/, android/, ...) once
flutter create . --platforms=web --project-name travel_xplorer

# 2. Install packages
flutter pub get

# 3. Run in Chrome
flutter run -d chrome

# Optional: tests and release build
flutter test
flutter build web
```

## Where each lab concept is used

| Concept | Where |
|---|---|
| Different widgets (Container, Row, Column, Stack, ListView/GridView, Card, buttons) | `widgets/destination_card.dart` (Stack + Card), `screens/explore_screen.dart` (SliverGrid), `trip_detail_screen.dart` (lists, Dismissible) |
| Responsive UI (MediaQuery / LayoutBuilder) | `utils/responsive.dart`, `screens/home_shell.dart` (BottomNav -> NavigationRail), grid columns adapt to width |
| Navigation (named routes + onGenerateRoute) | `routes/app_router.dart`, `Navigator.pushNamed` with arguments |
| Animations | Splash (AnimationController), Hero, AnimatedSwitcher, AnimatedContainer, TweenAnimationBuilder, custom page transitions |
| State management | `provider` with `TripProvider` + `SettingsProvider`; StatefulWidgets for local state |
| Themes + custom widgets | `theme/app_theme.dart` (light/dark, Material 3), `widgets/` folder |
| Forms + validation | `trip_form_screen.dart`, add-activity dialog, profile form in Settings |
