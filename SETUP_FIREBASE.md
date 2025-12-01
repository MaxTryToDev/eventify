# Configuration Firebase - Eventify

## 🚀 Étapes de configuration

### 1. Créer un projet Firebase
1. Aller sur [Firebase Console](https://console.firebase.google.com/)
2. Cliquer sur "Ajouter un projet"
3. Nom du projet : `eventify-demo`
4. Accepter les conditions et créer

### 2. Activer Authentication
1. Dans la console Firebase, aller dans "Authentication"
2. Cliquer sur "Commencer"
3. Onglet "Sign-in method"
4. Activer "E-mail/Mot de passe"

### 3. Activer Firestore Database
1. Aller dans "Firestore Database"
2. Cliquer sur "Créer une base de données"
3. Choisir "Commencer en mode test"
4. Sélectionner une région (europe-west1)

### 4. Configuration Web
1. Dans "Paramètres du projet" > "Vos applications"
2. Cliquer sur l'icône Web `</>`
3. Nom de l'app : `eventify-web`
4. Cocher "Configurer Firebase Hosting"
5. Copier la configuration

### 5. Remplacer la configuration
Dans `lib/firebase_options.dart`, remplacer les valeurs :

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'VOTRE_API_KEY',
  appId: 'VOTRE_APP_ID', 
  messagingSenderId: 'VOTRE_SENDER_ID',
  projectId: 'eventify-demo',
  authDomain: 'eventify-demo.firebaseapp.com',
  storageBucket: 'eventify-demo.appspot.com',
);
```

### 6. Règles Firestore
Dans Firestore > Règles, remplacer par :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /favorites/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

## ✅ Test de l'application

Une fois configuré :
1. `flutter run -d chrome`
2. Créer un compte avec email/mot de passe
3. Ajouter des favoris
4. Se déconnecter et se reconnecter
5. Vérifier que les favoris sont sauvegardés

## 🔧 Fonctionnalités disponibles

✅ Authentification email/mot de passe
✅ Navigation automatique après connexion  
✅ Favoris synchronisés par utilisateur
✅ Persistance des données Firebase
✅ Interface réactive aux changements d'état

## 📱 Structure des données

```
users/
  {userId}/
    favorites/
      {eventId}: {
        eventData: {...},
        addedAt: timestamp
      }
```

L'application est maintenant prête à fonctionner avec Firebase !