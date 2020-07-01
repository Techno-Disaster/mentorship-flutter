import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:mentorship_client/remote/repositories/auth_repository.dart';
import 'package:mentorship_client/auth/bloc.dart';

class MockUserRepository extends Mock implements AuthRepository {}

void main() {
  AuthBloc authenticationBloc;
  MockUserRepository userRepository;

  setUp(() {
    userRepository = MockUserRepository();
    authenticationBloc = AuthBloc(userRepository);
  });

  tearDown(() {
    authenticationBloc?.close();
  });

  test('initial state is correct', () {
    expect(authenticationBloc.initialState, AuthUninitialized());
  });

  test('close does not emit new states', () {
    expectLater(
      authenticationBloc,
      emitsInOrder([AuthUninitialized(), emitsDone]),
    );
    authenticationBloc.close();
  });
  group('LoggedOut', () {
    test('emits [uninitialized, loading, unauthenticated] when token is deleted', () {
      final expectedResponse = [
        AuthUninitialized(),
        AuthInProgress(),
        AuthUnauthenticated(
          justLoggedOut: true,
        ),
      ];

      expectLater(
        authenticationBloc,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.add(JustLoggedOut());
    });
  });
}
