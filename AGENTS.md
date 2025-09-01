# Repository Guidelines

## Project Structure & Module Organization
- `lib/presentation/`: UI pages and widgets (forms, animator).
- `lib/application/`: Controllers and orchestration logic.
- `lib/domain/`: Models, ODE (RK4, double pendulum), services.
- `test/`: Dart unit/widget tests (`*_test.dart`).
- `assets/`: App icon, fonts; registered in `pubspec.yaml`.
- Platform folders (`android/`, `ios/`, `macos/`, `web/`, etc.) are Flutter-generated.

## Build, Test, and Development Commands
- `flutter pub get`: Install dependencies.
- `flutter run -d <device>`: Run locally (e.g., `ios`, `macos`, `chrome`).
- `flutter test`: Run the full test suite.
- `flutter analyze`: Static analysis using `flutter_lints`.
- `dart format .`: Format code; combine with trailing commas for clean diffs.
- `dart fix --apply`: Apply recommended fixes where safe.
- Release builds: `flutter build ios --release`, `flutter build apk --release`, `flutter build web`.
- Icons: `dart run flutter_launcher_icons` (config in `pubspec.yaml`).

## Coding Style & Naming Conventions
- Dart style (2‑space indent, UTF‑8, null‑safe). Prefer `const` constructors and `final` fields.
- Files: `snake_case.dart`; classes: `UpperCamelCase`; members: `lowerCamelCase`.
- Prefer single quotes for strings; use trailing commas to enable formatter wrapping.
- Avoid `print`; rely on tests and assertions. Keep widgets small and composable.
- Lints: Managed by `analysis_options.yaml` (`flutter_lints`). Fix all analyzer warnings before PRs.

## Testing Guidelines
- Framework: `flutter_test`. Place tests under `test/` with `*_test.dart` names.
- Focus on domain determinism (RK4 integrator, double‑pendulum equations) and controller behavior.
- Examples: `flutter test test/rk4_test.dart`, `flutter test -r expanded`.
- Add minimal golden/widget tests for critical UI paths when feasible.

## Commit & Pull Request Guidelines
- Commits: Short, imperative subject; optional type prefix (e.g., `feat:`, `fix:`, `docs:`, `test:`). History already uses short prefixes (e.g., `add:`, `test:`).
- PRs: Clear description, rationale, and scope; link issues; include before/after screenshots or short clips for UI changes.
- Quality gate: CI‑equivalent locally — pass `flutter analyze`, `dart format --set-exit-if-changed .`, and `flutter test`.
- Keep PRs focused and reviewable (< ~300 lines of core changes when possible).

## Security & Configuration Tips
- Do not commit secrets or OS‑specific build artifacts. Use platform stores/keychains when needed.
- Register new assets/fonts in `pubspec.yaml`; bump `version:` for releases and update icons via the launcher‑icons task.
- For platform shipping steps, see README.md and SPEC.md.

