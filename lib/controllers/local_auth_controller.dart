import 'package:get/get.dart';
import '../services/local_auth_service.dart';

class LocalAuthController extends GetxController {
  final LocalAuthService _authService = LocalAuthService();
  final Rx<LocalUser?> _user = Rx<LocalUser?>(null);

  LocalUser? get user => _user.value;
  bool get isLoggedIn => _user.value != null;
  Rx<LocalUser?> get userStream => _user;

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  Future<void> _initAuth() async {
    await _authService.init();
    _user.value = _authService.currentUser;
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final user = await _authService.signInWithEmail(email, password);
      _user.value = user;
      Get.back();
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  Future<void> createAccount(String email, String password) async {
    try {
      final user = await _authService.createAccount(email, password);
      _user.value = user;
      Get.back();
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user.value = null;
  }
}