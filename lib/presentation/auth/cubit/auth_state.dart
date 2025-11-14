import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  /// Initial state - checking authentication status
  const factory AuthState.initial() = _Initial;

  /// User is authenticated
  const factory AuthState.authenticated({
    Map<String, dynamic>? userData,
  }) = _Authenticated;

  /// User is not authenticated
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Loading state during authentication operations
  const factory AuthState.loading() = _Loading;

  /// Error state
  const factory AuthState.error({
    required String message,
  }) = _Error;
}
