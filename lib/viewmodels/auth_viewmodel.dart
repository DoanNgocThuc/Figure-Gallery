import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, void>(() {
  return AuthViewModel();
});

class AuthViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> logout() async {
    ref.read(authRepositoryProvider).signOut();
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

      /// Resets the authentication state to a cleared/idle state by wrapping a null value.
      ///
      /// The `AsyncValue.data(null)` pattern is used here to:
      /// - Signal that an async operation has completed successfully
      /// - Clear any previous authentication data or error states
      /// - Provide a clean slate for the next authentication flow
      /// - Maintain type safety with the AsyncValue wrapper, allowing listeners to
      ///   distinguish between "loading", "error", and "cleared" states
      /// - Prevent null pointer exceptions by explicitly handling the null case
      ///   through the AsyncValue's data constructor rather than assigning null directly
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
