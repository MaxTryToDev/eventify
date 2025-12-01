import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/local_auth_controller.dart';
import '../controllers/local_favorites_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalAuthController authController = Get.find<LocalAuthController>();
    final LocalFavoritesController favoritesController = Get.find<LocalFavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        final user = authController.user;
        if (user == null) {
          return const Center(
            child: Text('Non connecté'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 16),
              Text(
                user.displayName ?? user.email ?? 'Utilisateur',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                user.email ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Favoris'),
                  subtitle: Text('${favoritesController.favorites.length} événements'),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => authController.signOut(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Se déconnecter'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}