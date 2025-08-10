# Pierwsze Soboty

Aplikacja mobilna Flutter (Android/iOS/Web) poświęcona nabożeństwu pierwszych sobót miesiąca.

## Uruchomienie

```
flutter pub get
flutter run
```

## Budowanie web

```
flutter build web --release --base-href /Pierwsze-soboty/ --pwa-strategy=offline-first
```

## CI/CD

Workflow GitHub Pages w `.github/workflows/deploy.yml` buduje i publikuje aplikację na gałęzi `gh-pages` przy pushu do `main` lub ręcznie.
