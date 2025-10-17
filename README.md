# app_sale_tickets

A new Flutter project.


flutter run --dart-define=onlyScanner=true


rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Ruta pública (lectura sin login)
    match /seat_sale/{docId} {
        allow get, list, read: if true;
    }

    // Resto del contenido protegido
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
