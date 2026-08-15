# GitHub Explorer (Flutter)

A polished, professional Flutter app to search and explore GitHub profiles and
their repositories.

## Features

- **Dark, gradient-accented UI** with a persistent bottom nav (**Search /
  Repositories / About**), matching the product mock-up.
- **Search tab** — hero header, username search field, and the last 5
  recent searches as tappable rows.
- **Profile screen** (pushed after a search) — reacts live to the search
  state: an illustrated **loading** view, an illustrated **User Not
  Found** / **Network Error** view (each with a "Try Again" action), or
  the loaded profile — avatar, name, bio, location, followers/following/
  repos stat strip, and a "View Repositories" CTA.
- **Repositories screen** — calls `GET /users/{username}/repos`, lists each
  repo's name, description, stars, language, and last-updated time, with a
  **Stars / Recently Updated** sort toggle.
- **About tab** — app info, data source, and tech stack.
- **Recent Searches** — the last 5 searched usernames are persisted on-device
  (`shared_preferences`), tappable for instant re-search, with a "Clear all"
  action.

## Architecture

```
lib/
  models/           # GithubUser, GithubRepo — typed fromJson()/toJson(), no raw map access in UI
  services/         # GithubApiService (http calls), RecentSearchStorage, typed exceptions
  providers/         # UserSearchProvider, RepoListProvider (ChangeNotifier / Provider)
  screens/           # SearchScreen, ProfileScreen, RepositoriesScreen,
                      # RepositoriesPlaceholderScreen, AboutScreen
  widgets/           # AppBottomNav, RepoCard, RecentSearchesList, StateIllustration
  utils/             # AppTheme (dark palette), formatters, language colors, navigation_helper
```

All screens share one Navigator stack with `SearchScreen` as root. The
bottom nav "switches tabs" by popping back to root (Search) or pushing the
Repositories/About screen on top of it — so functionally it's still a single
linear search → profile → repositories flow, just presented as tabs.

- **State management:** `provider` (ChangeNotifier). Each screen exposes an
  explicit enum-driven view state (`idle / loading / loaded / error`,
  `loading / loaded / empty / error`) so the UI is a pure function of state.
- **Networking:** `http` package, wrapped in `GithubApiService` with a 15s
  timeout and typed exceptions (`UserNotFoundException`, `NetworkException`,
  `ApiException`) translated to friendly messages in the providers.
- **Null safety:** fully null-safe; all model fields are typed and defensively
  parsed in `fromJson`.

## Getting started

> Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel).

```bash
cd github_explorer

# Generate the platform folders (android/ios/etc.) for this project.
# Safe to run on an existing project — it will NOT overwrite lib/ or pubspec.yaml.
flutter create --org com.example --project-name github_explorer .

flutter pub get
flutter run
```

## Building the release APK

```bash
flutter build apk --release
```

The output APK will be at:

```
build/app/outputs/flutter-apk/app-release.apk
```

Rename it per the required convention before submitting, e.g.:

```bash
cp build/app/outputs/flutter-apk/app-release.apk YourName_ToDo.apk
```

(Replace `YourName` with your actual name.)

## Notes

- No API token is required — this uses GitHub's public, unauthenticated REST
  API, which is rate-limited to 60 requests/hour per IP. A 403/429 response
  is surfaced to the user as a friendly rate-limit message.
- Tapping a repository card opens it in the browser via `url_launcher`.
