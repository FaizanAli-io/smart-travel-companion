# SMD Final Assignment — Flutter Advanced Application

**Theme:** Smart Travel Companion  
Build a feature-rich Flutter application integrating APIs, animations, state management, and clean architecture.

---

## 🚀 Core Features

### 1. Home Screen

- **Data Fetching:** Fetch places from the provided API.
- **UI Components:** Display image, title, and a favorite icon.
- **Interactions:** \* Pull-to-refresh functionality.
  - Search bar with **debounce** logic.
  - Category/place filters.
- **Animations:** Implement `AnimatedContainer`, `AnimatedOpacity`, and `AnimatedList`.

### 2. Detail Screen

- **Hero Animation:** Seamless transition for images from the Home Screen.
- **Weather Integration:** Real-time data fetching using the Weather API.
- **Expandable Content:** Use `AnimatedSize` for description expansion.
- **Loading States:** Use `AnimatedSwitcher` to toggle between loading and data views.

### 3. State Management

- **Structured Implementation:** Use **Riverpod**, **Bloc**, or **Provider**.

### 4. Navigation

- **Routing:** Implement Named routes or **GoRouter**.
- **Deep Linking/Passing:** Ability to pass complex objects between screens.

### 5. Offline Support

- **Caching:** Cache API data locally for offline access.

### 6. Error Handling

- **Resilience:** Implement Retry UI and custom empty states for better UX.

---

## 🌐 APIs

- **Photos/Places:** [https://jsonplaceholder.typicode.com/photos](https://jsonplaceholder.typicode.com/photos)
- **Weather:** [https://api.open-meteo.com/v1/forecast](https://api.open-meteo.com/v1/forecast)

---

## 🎁 Bonus Features

- Dark mode support
- Google Maps integration
- Push Notifications
- Pagination (Infinite scroll)

---

## 📊 Evaluation Criteria

| Category            | Weight |
| :------------------ | :----- |
| **Architecture**    | 25%    |
| **API + Errors**    | 20%    |
| **Animations**      | 20%    |
| **UI/UX**           | 15%    |
| **Offline Support** | 10%    |
| **Code Quality**    | 10%    |
