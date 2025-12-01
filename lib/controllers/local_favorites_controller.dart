import 'package:get/get.dart';
import '../models/event.dart';
import '../services/local_favorites_service.dart';
import '../controllers/local_auth_controller.dart';

class LocalFavoritesController extends GetxController {
  final LocalFavoritesService _favoritesService = LocalFavoritesService();
  late final LocalAuthController _authController;
  
  final RxList<Event> _favorites = <Event>[].obs;
  final RxBool _isLoading = false.obs;

  List<Event> get favorites => _favorites;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _authController = Get.find<LocalAuthController>();
    ever(_authController.userStream, _onAuthStateChanged);
    if (_authController.isLoggedIn) {
      _loadFavorites();
    }
  }

  void _onAuthStateChanged(dynamic user) {
    if (user != null) {
      _loadFavorites();
    } else {
      _favorites.clear();
    }
  }

  Future<void> _loadFavorites() async {
    if (!_authController.isLoggedIn) return;
    
    final favorites = await _favoritesService.getFavorites(_authController.user!.uid);
    _favorites.assignAll(favorites);
  }

  bool isFavorite(Event event) {
    return _favorites.any((e) => e.id == event.id);
  }

  Future<void> toggleFavorite(Event event) async {
    if (!_authController.isLoggedIn) {
      Get.snackbar('Connexion requise', 'Veuillez vous connecter pour ajouter des favoris');
      return;
    }

    _isLoading.value = true;
    try {
      if (isFavorite(event)) {
        await _favoritesService.removeFavorite(_authController.user!.uid, event.id);
      } else {
        await _favoritesService.addFavorite(_authController.user!.uid, event);
      }
      await _loadFavorites();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier les favoris');
    } finally {
      _isLoading.value = false;
    }
  }
}