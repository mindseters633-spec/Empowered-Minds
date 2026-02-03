# Empowered Minds - App de PNL

Este repositorio contiene el prototipo y los archivos iniciales para la aplicación móvil "Empowered Minds" (PNL). Incluye:
- Logo (logo.svg)
- Prototipo Flutter (lib/main.dart)
- Configuración inicial de Firebase Cloud Functions (functions/index.js)
- Esquema sugerido de Firestore (firestore-schema.md)
- Panel admin README (admin/README.md)
- Workflow de ejemplo para CI (/.github/workflows/flutter.yml)

Siguientes pasos (resumen):
1. Crear proyecto en Firebase y configurar Firestore, Auth y Cloud Messaging.
2. Generar `firebase_options.dart` usando FlutterFire CLI e incluirlo en `lib/`.
3. Ajustar `android` y `ios` para FCM (APNs) y configurar claves en Firebase.
4. Revisar y desplegar la Cloud Function: `functions/`.
5. Desplegar panel admin (recomendado: Vercel o Firebase Hosting).

Más instrucciones detalladas están en `admin/README.md` y comentarios dentro de los archivos.
