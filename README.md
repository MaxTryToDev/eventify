# Eventify

Une application Flutter moderne pour découvrir et gérer des événements, développée avec le pattern MVC et GetX pour la gestion d'état.

## 📱 Fonctionnalités

- **Découverte d'événements** : Parcourez les événements disponibles par pays
- **Recherche avancée** : Trouvez des événements spécifiques
- **Favoris** : Sauvegardez vos événements préférés localement
- **Géolocalisation** : Localisez les événements sur une carte interactive
- **Authentification locale** : Sécurisez l'accès avec l'authentification biométrique
- **Interface multiplateforme** : Support iOS, Android, Web, Windows, macOS et Linux

## 🏗️ Architecture

Le projet suit le pattern **MVC (Model-View-Controller)** avec :

- **Models** : Définition des structures de données (Event, Venue, Attraction, User, Country)
- **Views** : Interface utilisateur avec navigation par onglets
- **Controllers** : Logique métier avec GetX pour la gestion d'état
- **Services** : Couche d'accès aux données (API Ticketmaster, stockage local)

## 🛠️ Technologies utilisées

- **Flutter** : Framework de développement multiplateforme
- **GetX** : Gestion d'état, navigation et injection de dépendances
- **HTTP** : Requêtes API REST
- **Flutter Map** : Cartes interactives avec OpenStreetMap
- **Geolocator** : Services de géolocalisation
- **Shared Preferences** : Stockage local des données
- **Local Auth** : Authentification biométrique

## 📦 Installation

### Prérequis
- Flutter SDK (>=3.0.0)
- Dart SDK
- IDE (VS Code, Android Studio, etc.)

### Étapes d'installation

1. **Cloner le projet**
```bash
git clone <url-du-repo>
cd eventify
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Lancer l'application**
```bash
flutter run
```

## 🔧 Configuration

### API Ticketmaster
L'application utilise l'API Ticketmaster pour récupérer les événements. La clé API est configurée dans `lib/services/event_service.dart`.

### Permissions
L'application nécessite les permissions suivantes :
- **Géolocalisation** : Pour localiser les événements
- **Internet** : Pour les requêtes API
- **Authentification biométrique** : Pour sécuriser l'accès

## 📱 Écrans principaux

1. **Accueil** : Liste des événements populaires
2. **Recherche** : Recherche d'événements avec filtres
3. **Favoris** : Événements sauvegardés localement
4. **Profil** : Gestion du compte utilisateur

## 🏃♂️ Commandes utiles

```bash
# Analyser le code
flutter analyze

# Lancer les tests
flutter test

# Construire pour production
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

## 📁 Structure du projet

```
lib/
├── controllers/           # Contrôleurs GetX
├── core/                 # Configuration et utilitaires
├── models/               # Modèles de données
├── services/             # Services (API, stockage)
├── utils/                # Fonctions utilitaires
├── views/                # Écrans et widgets
└── main.dart            # Point d'entrée
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit les changements (`git commit -m 'Ajout nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

---

Développé avec ❤️ en Flutter