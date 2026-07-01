# Skoleom AI Studio

Application Flutter App + Web mobile-first avec UI sombre premium et connexion API configurable.

## Lancer en local mock

```bash
flutter pub get
flutter run -d chrome
```

Sans `SKOLEOM_API_BASE_URL`, l’application utilise le `MockRepository` pour rester entièrement fonctionnelle.

## Lancer avec backend réel

```bash
flutter run -d chrome \
  --dart-define=SKOLEOM_API_BASE_URL="https://votre-api.com" \
  --dart-define=SKOLEOM_API_TOKEN="votre-token" \
  --dart-define=SKOLEOM_PROJECTS_ENDPOINT="/projects" \
  --dart-define=SKOLEOM_CHAT_ENDPOINT="/chat"
```

## Secrets GitHub à ajouter

Dans GitHub > Settings > Secrets and variables > Actions :

- `SKOLEOM_API_BASE_URL`
- `SKOLEOM_API_TOKEN`
- `SKOLEOM_AUTH_LOGIN_ENDPOINT`
- `SKOLEOM_PROJECTS_ENDPOINT`
- `SKOLEOM_CHAT_ENDPOINT`
- `SKOLEOM_AGENTS_ENDPOINT`
- `SKOLEOM_USAGE_ENDPOINT`
- `SKOLEOM_BILLING_ENDPOINT`

Le workflow `.github/workflows/flutter-web.yml` injecte ces valeurs avec `--dart-define` pendant le build.

## Écrans connectés

- Onboarding / Login API
- Dashboard
- Vibe Coding Chat
- Projets
- Détail projet avec redéploiement
- Agents IA
- Usage & rate limits
- Plan & billing
- Settings

## Preview statique

Ouvrir `public/preview.html` pour une visualisation immédiate HTML/CSS.
