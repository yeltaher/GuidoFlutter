import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/repositories/user_repository.dart';
import 'package:isar/isar.dart';

class FakeIsar implements Isar {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserRepository Unit Tests', () {
    late UserRepository repository;
    late SharedPreferences prefs;
    late FakeIsar fakeIsar;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      fakeIsar = FakeIsar();
      repository = UserRepository(fakeIsar, prefs);
    });

    test('profileName returns empty string by default', () {
      expect(repository.profileName, "");
    });

    test('setProfileName updates the profileName', () async {
      await repository.setProfileName("TestUser");
      expect(repository.profileName, "TestUser");
    });

    test('isOnboarded returns false by default', () {
      expect(repository.isOnboarded, false);
    });

    test('setOnboarded updates the onboarded status', () async {
      await repository.setOnboarded(true);
      expect(repository.isOnboarded, true);
    });
  });
}
