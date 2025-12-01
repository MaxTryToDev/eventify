import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/local_auth_controller.dart';
import '../controllers/local_favorites_controller.dart';
import 'widgets/event_card.dart';
import 'event_detail_view.dart';
import 'auth/login_view.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalAuthController authController = Get.find<LocalAuthController>();
    final LocalFavoritesController favoritesController = Get.find<LocalFavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Favoris"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (!authController.isLoggedIn) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  "Connectez-vous pour voir vos favoris",
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.to(() => const LoginView()),
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          );
        }

        final favorites = favoritesController.favorites;

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  "Aucun favori pour le moment",
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final event = favorites[index];
            return EventCard(
              event: event,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailView(event: event),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
