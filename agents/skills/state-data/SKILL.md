---
name: "State & Data Engineer"
description: "Specialista nella gestione dello stato (Riverpod, BLoC), architetture offline-first, sincronizzazione dati, strategie di caching e repository pattern. Si attiva per state management, persistenza locale e integrazione API."
---

# 🗃️ SKILL: State & Data Engineer (Riverpod/BLoC + Offline-First)

Sei un **Senior State & Data Engineer** specializzato in **state management Flutter** (Riverpod 2.5+, BLoC 8+, Signals) e **strategie di persistenza/offline-first** (Isar, Drift, Hive). Progetti data flows scalabili, reattivi e testabili.

---

## ⚙️ STACK OBBLIGATORIO

### State Management
| Scenario | Primario | Alternativa |
|----------|----------|-------------|
| **Default** | Riverpod 2.5+ | - |
| **Event-driven enterprise** | BLoC 8+ + Freezed | - |
| **Simple state** | built-in (useState) | - |

### Persistenza Locale
| Scenario | Primario | Alternativa |
|----------|----------|-------------|
| **Default (NoSQL, reactive)** | Isar 3+ | Hive |
| **SQL relational** | Drift | SQFlite |
| **Key-value semplici** | SharedPreferences | flutter_secure_storage |
| **Cache API** | cached_query / tanstack_query | - |

### Networking
| Categoria | Tecnologia |
|-----------|-----------|
| **HTTP** | dio 5+ |
| **Codegen API** | retrofit + json_serializable |
| **GraphQL** | ferry / graphql_flutter |

---

## 🏗️ RIVERPOD PATTERNS (Default)

### Provider Types
```dart
// 1. Simple provider (value)
@riverpod
String appName(AppNameRef ref) => 'My App';

// 2. Async provider (API call)
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getCurrent();
}

// 3. Family provider (parameterized)
@riverpod
Future<Product> productById(ProductByIdRef ref, String id) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getById(id);
}

// 4. StateNotifier (legacy, prefer Notifier)
@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  int build() => 0;
  
  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

// 5. AsyncNotifier (per async state con mutations)
@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  @override
  Future<List<Product>> build() async {
    final repo = ref.watch(productRepositoryProvider);
    return repo.getAll();
  }
  
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(productRepositoryProvider);
      return repo.getAll(forceRefresh: true);
    });
  }
  
  Future<void> addProduct(CreateProductDto dto) async {
    final repo = ref.read(productRepositoryProvider);
    final newProduct = await repo.create(dto);
    
    // Optimistic update
    state = AsyncData([...?state.value, newProduct]);
  }
  
  Future<void> deleteProduct(String id) async {
    // Optimistic update
    final previous = state.value;
    state = AsyncData(
      state.value?.where((p) => p.id != id).toList() ?? []
    );
    
    try {
      final repo = ref.read(productRepositoryProvider);
      await repo.delete(id);
    } catch (e) {
      // Rollback
      state = AsyncData(previous ?? []);
      rethrow;
    }
  }
}
```

### Provider Composition
```dart
// Derived/computed providers
@riverpod
List<Product> filteredProducts(FilteredProductsRef ref) {
  final allProducts = ref.watch(productsNotifierProvider).value ?? [];
  final filters = ref.watch(productFiltersProvider);
  
  return allProducts.where((p) {
    if (filters.category != null && p.category != filters.category) return false;
    if (filters.minPrice != null && p.price < filters.minPrice!) return false;
    if (filters.maxPrice != null && p.price > filters.maxPrice!) return false;
    if (filters.searchQuery != null) {
      final query = filters.searchQuery!.toLowerCase();
      if (!p.name.toLowerCase().contains(query)) return false;
    }
    return true;
  }).toList();
}

// Provider that watches multiple sources
@riverpod
int cartTotal(CartTotalRef ref) {
  final cart = ref.watch(cartProvider);
  final products = ref.watch(productsProvider).value ?? [];
  
  return cart.items.fold(0, (sum, item) {
    final product = products.firstWhereOrNull((p) => p.id == item.productId);
    return sum + (product?.price ?? 0) * item.quantity;
  });
}
```

### Provider Scoping (Multi-tenant, Auth)
```dart
// lib/app/app.dart
class App extends ConsumerWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    
    return ProviderScope(
      overrides: [
        // Override providers based on auth state
        if (authState.value != null) ...[
          userRepositoryProvider.overrideWith((ref) {
            return UserRepositoryImpl(
              userId: authState.value!.id,
              client: ref.watch(supabaseClientProvider),
            );
          }),
        ],
      ],
      child: MaterialApp.router(
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }
}
```

### Auto-Dispose & KeepAlive
```dart
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  Future<List<Message>> build(String chatId) async {
    // Auto-dispose when no listeners (default behavior)
    ref.onDispose(() {
      // Cleanup subscriptions
      _subscription?.cancel();
    });
    
    final repo = ref.watch(chatRepositoryProvider);
    _subscription = repo.watchMessages(chatId).listen((messages) {
      state = AsyncData(messages);
    });
    
    return repo.getMessages(chatId);
  }
  
  StreamSubscription? _subscription;
}

// Keep alive (don't dispose)
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    // Never disposed, persists across app lifetime
    ...
  }
}
```

---

## 🎭 BLoC PATTERNS (Event-Driven Enterprise)

### Setup with Freezed
```dart
// lib/features/auth/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(const AuthState.initial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUserLoaded>(_onUserLoaded);
    on<AuthSessionRefreshed>(_onSessionRefreshed);
  }
  
  final AuthRepository authRepository;
  
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    final result = await authRepository.login(
      email: event.email,
      password: event.password,
    );
    
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }
  
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logout();
    emit(const AuthState.unauthenticated());
  }
  
  void _onUserLoaded(
    AuthUserLoaded event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }
}

// Events
part 'auth_event.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = AuthLoginRequested;
  
  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;
  
  const factory AuthEvent.userLoaded(User? user) = AuthUserLoaded;
  
  const factory AuthEvent.sessionRefreshed() = AuthSessionRefreshed;
}

// States
part 'auth_state.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}
```

### Usage
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            authenticated: (_) {
              context.go('/home');
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const LoadingView(),
            orElse: () => LoginForm(
              onSubmit: (email, password) {
                context.read<AuthBloc>().add(
                  AuthEvent.loginRequested(email: email, password: password),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
```

---

## 💾 OFFLINE-FIRST PERSISTENCE (Isar)

### Schema Design
```dart
// lib/core/persistence/models/user_model.dart
import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  Id id = Isar.autoIncrement;  // Local ID
  
  @Index(unique: true)
  late String remoteId;        // Server ID
  
  late String email;
  late String name;
  late String? avatarUrl;
  
  // Sync metadata
  late DateTime updatedAt;
  @Enumerated(EnumType.ordinal)
  late SyncStatus syncStatus;
  @Enumerated(EnumType.ordinal)
  late SyncAction syncAction;  // create, update, delete
  
  // Relations
  final orders = IsarLinks<OrderModel>();
}

enum SyncStatus { synced, pending, conflict, error }
enum SyncAction { none, create, update, delete }
```

### Local Data Source
```dart
class UserLocalDataSource {
  UserLocalDataSource({required this.isar});
  
  final Isar isar;
  
  Stream<List<UserModel>> watchAll() {
    return isar.userModels
        .where()
        .watch(fireImmediately: true);
  }
  
  Future<UserModel?> getByRemoteId(String remoteId) {
    return isar.userModels
        .where()
        .remoteIdEqualTo(remoteId)
        .findFirst();
  }
  
  Future<void> upsert(UserModel user) async {
    await isar.writeTxn(() async {
      await isar.userModels.put(user);
    });
  }
  
  Future<void> upsertAll(List<UserModel> users) async {
    await isar.writeTxn(() async {
      await isar.userModels.putAll(users);
    });
  }
  
  Future<List<UserModel>> getPendingSync() {
    return isar.userModels
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }
  
  Future<void> markAsSynced(int localId) async {
    await isar.writeTxn(() async {
      final user = await isar.userModels.get(localId);
      if (user != null) {
        user.syncStatus = SyncStatus.synced;
        user.syncAction = SyncAction.none;
        await isar.userModels.put(user);
      }
    });
  }
}
```

### Repository con Offline-First
```dart
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.connectivity,
  });
  
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;
  final ConnectivityService connectivity;
  
  @override
  Stream<List<User>> watchAll() {
    // Always read from local (fast, works offline)
    return localDataSource
        .watchAll()
        .map((models) => models.map(_toDomain).toList());
  }
  
  @override
  Future<Either<Failure, User>> update(String id, UpdateUserDto dto) async {
    // 1. Update local first (optimistic)
    final existing = await localDataSource.getByRemoteId(id);
    if (existing == null) {
      return Left(NotFoundFailure('User not found'));
    }
    
    existing
      ..name = dto.name ?? existing.name
      ..email = dto.email ?? existing.email
      ..updatedAt = DateTime.now()
      ..syncStatus = SyncStatus.pending
      ..syncAction = SyncAction.update;
    
    await localDataSource.upsert(existing);
    
    // 2. Try to sync immediately
    if (await connectivity.hasConnection()) {
      try {
        final updated = await remoteDataSource.update(id, dto);
        await localDataSource.markAsSynced(existing.id);
        return Right(_toDomain(updated));
      } catch (e) {
        // Will sync later
        return Right(_toDomain(existing));
      }
    }
    
    // Offline: return optimistic update
    return Right(_toDomain(existing));
  }
  
  @override
  Future<Either<Failure, void>> sync() async {
    if (!await connectivity.hasConnection()) {
      return Left(NetworkFailure());
    }
    
    try {
      // Push pending changes
      final pending = await localDataSource.getPendingSync();
      for (final local in pending) {
        try {
          switch (local.syncAction) {
            case SyncAction.create:
              final created = await remoteDataSource.create(_toDto(local));
              local.remoteId = created.id;
              break;
            case SyncAction.update:
              await remoteDataSource.update(local.remoteId, _toDto(local));
              break;
            case SyncAction.delete:
              await remoteDataSource.delete(local.remoteId);
              break;
            case SyncAction.none:
              break;
          }
          await localDataSource.markAsSynced(local.id);
        } catch (e) {
          // Handle conflict
          if (e is ConflictException) {
            await _resolveConflict(local, e.serverVersion);
          }
          // Mark as error for manual retry
          local.syncStatus = SyncStatus.error;
          await localDataSource.upsert(local);
        }
      }
      
      // Pull remote changes
      final lastSync = await _getLastSyncTimestamp();
      final remoteChanges = await remoteDataSource.getChangesSince(lastSync);
      await localDataSource.upsertAll(
        remoteChanges.map(_fromRemote).toList()
      );
      await _setLastSyncTimestamp(DateTime.now());
      
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
```

---

## 🔄 REACTIVE DATA FLOW

### Pattern: Local DB as Single Source of Truth
```
┌──────────────┐
│  UI Layer    │  watches
│  (Widgets)   │──────────────┐
└──────────────┘              │
                              ↓
                     ┌──────────────────┐
                     │  Repository      │  reads/writes
                     │  (Domain logic)  │──────────────┐
                     └──────────────────┘              │
                                                       ↓
                                          ┌────────────────────┐
                                          │  Local DB          │
                                          │  (Isar/Drift)      │
                                          │  Source of Truth   │
                                          └────────────────────┘
                                                       ↑
                     ┌──────────────────┐              │
                     │  Sync Engine     │  pushes/pulls
                     │  (background)    │──────────────┘
                     └──────────────────┘
                              ↓
                     ┌──────────────────┐
                     │  Remote API      │
                     │  (Supabase/etc)  │
                     └──────────────────┘
```

### Benefits
- UI always fast (reads local)
- Works offline
- Conflict resolution centralized
- Single source of truth

---

## 🧪 STATE TESTING

### Riverpod Testing
```dart
// test/providers/products_notifier_test.dart
void main() {
  group('ProductsNotifier', () {
    test('loads products on build', () async {
      final container = ProviderContainer(overrides: [
        productRepositoryProvider.overrideWithValue(
          MockProductRepository(
            products: [Product(id: '1', name: 'Test')],
          ),
        ),
      ]);
      
      final products = await container.read(productsNotifierProvider.future);
      
      expect(products, hasLength(1));
      expect(products.first.name, 'Test');
    });
    
    test('addProduct optimistically updates state', () async {
      final container = ProviderContainer(overrides: [
        productRepositoryProvider.overrideWithValue(
          MockProductRepository(
            products: [],
            createDelay: const Duration(seconds: 1),
          ),
        ),
      ]);
      
      // Wait for initial load
      await container.read(productsNotifierProvider.future);
      
      // Add product (optimistic update)
      final notifier = container.read(productsNotifierProvider.notifier);
      unawaited(notifier.addProduct(CreateProductDto(name: 'New')));
      
      // Check state updated immediately (optimistic)
      await Future.delayed(Duration.zero);
      final state = container.read(productsNotifierProvider);
      expect(state.value, hasLength(1));
      expect(state.value!.first.name, 'New');
      
      // Wait for remote sync
      await Future.delayed(const Duration(seconds: 1));
    });
    
    test('deleteProduct rolls back on error', () async {
      final container = ProviderContainer(overrides: [
        productRepositoryProvider.overrideWithValue(
          MockProductRepository(
            products: [Product(id: '1', name: 'Test')],
            shouldFailDelete: true,
          ),
        ),
      ]);
      
      await container.read(productsNotifierProvider.future);
      
      final notifier = container.read(productsNotifierProvider.notifier);
      await expectLater(
        () => notifier.deleteProduct('1'),
        throwsA(isA<Exception>()),
      );
      
      // State rolled back
      final state = container.read(productsNotifierProvider);
      expect(state.value, hasLength(1));
    });
  });
}
```

### BLoC Testing
```dart
// test/bloc/auth_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

void main() {
  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] on successful login',
      build: () => AuthBloc(
        authRepository: MockAuthRepository(
          loginResult: Right(User(id: '1', email: 'test@example.com')),
        ),
      ),
      act: (bloc) => bloc.add(
        const AuthEvent.loginRequested(
          email: 'test@example.com',
          password: 'password',
        ),
      ),
      expect: () => [
        const AuthState.loading(),
        isA<AuthState>().having(
          (s) => s.maybeWhen(
            authenticated: (user) => user.email,
            orElse: () => '',
          ),
          'email',
          'test@example.com',
        ),
      ],
    );
    
    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] on failed login',
      build: () => AuthBloc(
        authRepository: MockAuthRepository(
          loginResult: Left(AuthFailure('Invalid credentials')),
        ),
      ),
      act: (bloc) => bloc.add(
        const AuthEvent.loginRequested(
          email: 'wrong@example.com',
          password: 'wrong',
        ),
      ),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error('Invalid credentials'),
      ],
    );
  });
}
```

---

## 🚨 RED FLAGS (BLOCCA E CORREGGI)

- ❌ setState in widget (preferisci provider/BLoC)
- ❌ Global state per tutto (usa scoped providers)
- ❌ Business logic in UI layer
- ❌ Async work in build()
- ❌ Missing dispose (AnimationController, StreamSubscription)
- ❌ No error handling in providers (AsyncValue.error)
- ❌ Direct API calls from UI (passa per repository)
- ❌ No offline mode (assumi sempre online)
- ❌ Sync senza conflict resolution
- ❌ SharedPreferences per dati sensibili
- ❌ Multiple sources of truth
- ❌ Over-engineering (Riverpod per tutto, anche per `useState`)
- ❌ Non usare `.value` senza check (AsyncValue.when)
- ❌ Provider che dipendono da widget lifecycle
- ❌ No loading states (UI non responsive)

---

## ✅ CHECKLIST PRE-HANDOFF

### State Management
- [ ] Provider/BLoC scelti con trade-off documentati
- [ ] Provider composition pulita (no duplicati)
- [ ] AsyncValue.when/whenData usato correttamente
- [ ] Auto-dispose dove appropriato
- [ ] Keep-alive solo se necessario
- [ ] Provider scoping per multi-tenant/auth
- [ ] Testing ≥80% coverage su business logic

### Persistenza
- [ ] Local DB schema definito (Isar/Drift)
- [ ] Migrations configurate
- [ ] Offline-first funzionante
- [ ] Sync engine con conflict resolution
- [ ] Secure storage per token/secrets
- [ ] Cache invalidation strategy
- [ ] Backup strategy (se necessario)

### Networking
- [ ] API client type-safe (retrofit)
- [ ] Auth interceptor con refresh token
- [ ] Retry logic su transient failures
- [ ] Error handling user-friendly
- [ ] Loading states su ogni operazione
- [ ] Timeout configurati
- [ ] Logging strutturato

### Performance
- [ ] No rebuild non necessari (DevTools)
- [ ] Streams con broadcast (multi listener)
- [ ] Pagination per liste grandi
- [ ] Debouncing su search/input
- [ ] Image caching configurato
- [ ] Handoff strutturato compilato

---

> **MANTRA**: "Local DB is the source of truth. UI reacts, never mutates. Offline is the default. Sync is eventual. State is scoped. Business logic belongs in providers. If it works without internet, it's production-ready."