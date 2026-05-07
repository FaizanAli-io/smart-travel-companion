# Smart Travel Companion

Smart Travel Companion is a Flutter travel discovery app built for the SMD final assignment. It combines offline-first place browsing, animated navigation, search and filters, favorites, a map-style recommendations view, and a detail screen with weather information.

## What The App Does

The app helps users browse scenic destinations, save favorites, inspect destination details, and continue using the app when the network is unavailable. When offline mode is active, or when the connection drops, the app falls back to a cached subset of places instead of showing the full catalog.

The main experience is split across four shell tabs:

1. Home for browsing curated places.
2. Map for nearest recommendations and location-focused discovery.
3. Favorites for saved destinations.
4. Profile for app controls, including offline mode and theme switching.

## Key Features

### Offline Support

The app keeps a cached subset of places in local storage using `SharedPreferences`.

When the app is online, it attempts to fetch fresh place data and stores a cache snapshot. When the app is offline, or when offline mode is toggled from Profile, the UI only shows the cached subset. This keeps the experience usable without exposing the full place list.

Behavior summary:

1. Online state loads the available places and writes them to the local cache.
2. Offline state uses the cache only.
3. If no cache exists yet, the app falls back to a small built-in seed set so the UI still has content.
4. Pull-to-refresh will re-check the source and preserve the cache fallback if the network is unavailable.

### Home Screen

The Home tab is the primary discovery surface.

It includes:

1. A prominent search entry point.
2. Quick feed filters for All, Favorites, and Recent.
3. Offline banner messaging when the app is in an offline session.
4. Destination cards with hero images, category badges, and favorite toggles.

The list is animated with staggered entrances, and each destination card animates into view for a softer browsing experience.

### Search And Filters

The Search screen supports:

1. Debounced text search.
2. Sort by recommended, name, or region.
3. Region filtering.
4. Favorites-only filtering.

Search results are animated in sequence, so the screen feels responsive instead of static while the query changes.

### Detail Screen

Each place opens a full detail page that includes:

1. A hero transition from the card image.
2. An expandable about section.
3. Weather fetched from the Open-Meteo API.
4. Loading and error states for the weather widget.
5. A quick jump button to show the destination on the map tab.

The about section uses `AnimatedSize`, and the weather container uses `AnimatedSwitcher` so content changes feel polished.

### Map Screen

The Map tab is a ranked destination view based on distance from Karachi, Pakistan.

It shows:

1. A stylized world-map panel.
2. Pins for the nearest cached places.
3. An animated ranked list of the top five places.
4. A focused destination card for the selected pin or the top recommendation.

This screen is also cached-place aware, so if the app is offline the map only reflects the places available in the local subset.

### Favorites Screen

Favorites are stored locally in app state and rendered from the same cached place list as the rest of the app. The screen shows saved destinations, a count, and an empty state when nothing is bookmarked.

### Theme And App Shell

The app supports light and dark themes, and navigation is handled by `GoRouter`.

Route transitions now fade and slide into place, which makes page changes feel smoother across the app.

## Architecture Overview

The app uses a lightweight clean structure:

1. `data/` holds the local destination seed data.
2. `models/` defines the place and weather data structures.
3. `services/` owns fetching, caching, and API integration.
4. `providers/` contains Riverpod state and derived selectors.
5. `screens/` contains the main UI surfaces.
6. `widgets/` holds reusable UI pieces such as cards, state views, and entrance animations.

### State Management

Riverpod drives the shared app state.

Important providers include:

1. `placesProvider` for cached and fetched places.
2. `favoritesProvider` for bookmarked destinations.
3. `recentPlaceIdsProvider` for recent activity.
4. `searchQueryProvider`, `selectedRegionProvider`, and `selectedSortProvider` for search state.
5. `offlineModeProvider` for forcing offline behavior.
6. `themeModeProvider` for app theme selection.

### Routing

The app uses named routes via `GoRouter`.

Primary routes:

1. `/` for the main shell.
2. `/search` for search and filtering.
3. `/detail/:id` for destination detail pages.
4. `/offline` for the offline information screen.
5. `/theme-preview` for theme inspection.
6. `/info/:section` for informational content.

## APIs Used

The app integrates two remote APIs:

1. Places and photos source: `https://jsonplaceholder.typicode.com/photos`
2. Weather source: `https://api.open-meteo.com/v1/forecast`

The photos API is used as a lightweight remote signal for refreshing place content, while the app's destination metadata comes from the curated local dataset. Weather details on the detail screen are fetched live for the selected destination coordinates.

## Animation Design

The app uses motion to reinforce hierarchy instead of treating animation as decoration.

Implemented motion includes:

1. Page transitions with fade and slide.
2. Staggered entrances for lists and controls.
3. Hero image transitions between cards and detail pages.
4. Animated size changes for expandable content.
5. Animated switchers for loading and data state changes.
6. Animated scale and container transitions in the map and place cards.

## How Offline Mode Works

There are two offline paths:

1. Automatic offline fallback when the network is unavailable.
2. Manual offline mode from the Profile screen.

In both cases, the app switches to the cached subset of destinations. That means the user still sees a real browsing experience, but only with places that were cached before the connection disappeared or the offline mode was enabled.

## Project Structure

```text
lib/
	data/              Local seed destination data
	models/            Travel place and weather models
	providers/         Riverpod state and derived selectors
	router/            GoRouter configuration
	screens/           App screens and shell tabs
	services/          API and caching logic
	theme/             Light and dark theme definitions
	widgets/           Shared UI widgets and animations
```

## Running The App

1. Install Flutter dependencies with `flutter pub get`.
2. Run the app with `flutter run`.
3. Open the Profile tab to toggle offline mode or switch themes.
4. Use Home or Search to explore destinations.
5. Open any destination to view details, weather, and map context.

## Notes For Reviewers

1. The offline subset is intentional. It is not a full local mirror of all remote data.
2. The app is designed to stay useful even with no connection rather than showing an empty error state.
3. Animations are spread across the major interaction surfaces so the UI feels cohesive instead of isolated.

## Development Notes

If you extend the app later, the safest places to hook new behavior are:

1. `lib/services/api_service.dart` for caching or new remote integrations.
2. `lib/providers/app_providers.dart` for shared state.
3. `lib/screens/` for page-level interaction changes.
4. `lib/widgets/` for reusable motion and card patterns.

## Credits

This project uses Flutter, Riverpod, GoRouter, SharedPreferences, Cached Network Image, Google Fonts, HTTP, and connectivity support to deliver the travel companion experience.
