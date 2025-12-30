import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';

// 1. The Provider
final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, void>(() {
  return AuthViewModel();
});

// 2. The ViewModel Class
class AuthViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is idle (null)
  }

  Future<void> authenticate({
    required String email,
    required String password,
    required bool isLogin,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repo = ref.read(authRepositoryProvider);

      if (isLogin) {
        await repo.login(email, password);
      } else {
        await repo.signUp(email, password);
      }

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
