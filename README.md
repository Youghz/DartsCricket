# Darts Cricket

Cross-platform mobile app for scoring darts Cricket (Cutthroat) games. Built with Flutter, deployable to iOS, Android, and Web.

## Features

- Score tracking for Cricket Cutthroat mode (15–20 + Bull)
- Multi-player support
- Clean Material Design UI with custom darts-themed icon
- Web deployment via Docker + Nginx

## Tech Stack

### Mobile
- **Flutter 3.24** + **Dart** — Cross-platform UI framework
- **Material Design 3** — Native look and feel on iOS and Android
- **Cupertino Icons** — iOS-style iconography

### Build & Deploy
- **Docker** — Multi-stage build (Flutter build → Nginx serve)
- **Nginx Alpine** — Lightweight web server for the compiled SPA
- **Flutter Launcher Icons** — Automated icon generation for all platforms

### Tooling
- **flutter_lints** — Dart static analysis rules
- **change_app_package_name** — Package name management across platforms
- **analysis_options.yaml** — Strict lint configuration

## Development

```bash
# Run in development
flutter run

# Build for web
flutter build web

# Build and serve with Docker
docker build -t darts-cricket .
docker run -p 8080:80 darts-cricket
```

## Platforms

| Platform | Status |
|----------|--------|
| Android  | Supported |
| iOS      | Supported |
| Web      | Supported (Docker + Nginx) |
| Linux    | Supported |
| macOS    | Supported |
| Windows  | Supported |
