# Skoleom AI Studio

Application Flutter App + Web mobile-first avec UI sombre premium.

## Correctifs build web

- Suppression des dépendances externes `http` et `google_fonts` qui provoquaient les erreurs `Couldn't resolve the package`.
- Remplacement du client HTTP par un transport natif conditionnel `dart:html` pour le web et `dart:io` pour mobile/desktop.
- Thème Flutter sans import `GoogleFonts`.
- Correction du KPI dynamique du dashboard sans constructeur `const` invalide.

## Lancer en local

Commande : flutter pub get

Commande : flutter run -d chrome

Sans `SKOLEOM_API_BASE_URL`, l’application utilise le repository mock local.

## Build web

Commande : flutter build web --release --base-href "/"

## API réelle

Ajouter au build les valeurs `--dart-define` :

- SKOLEOM_API_BASE_URL
- SKOLEOM_API_TOKEN
- SKOLEOM_PROJECTS_ENDPOINT
- SKOLEOM_CHAT_ENDPOINT
- SKOLEOM_AGENTS_ENDPOINT
- SKOLEOM_USAGE_ENDPOINT
- SKOLEOM_BILLING_ENDPOINT
