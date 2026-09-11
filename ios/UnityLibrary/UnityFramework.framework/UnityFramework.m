#import "UnityFramework.h"

@interface UnityAppController ()
@end

@implementation UnityAppController

- (instancetype)init {
    self = [super init];
    if (self) {
        _rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _rootView.backgroundColor = [UIColor colorWithRed:0.04f green:0.06f blue:0.12f alpha:1.0f];
        _rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor blackColor];
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view = _rootView;
        _window.rootViewController = vc;
    }
    return self;
}

- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _rootView.backgroundColor = [UIColor colorWithRed:0.04f green:0.06f blue:0.12f alpha:1.0f];
        _rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _rootView;
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {}

@end

@interface UnityFramework () {
    UnityAppController *_appController;
    NSHashTable<id<UnityFrameworkListener>> *_listeners;
    BOOL _isPaused;
}
@end

@implementation UnityFramework

static UnityFramework *_sharedInstance = nil;

+ (UnityFramework *)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UnityFramework alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _appController = [[UnityAppController alloc] init];
        _listeners = [NSHashTable weakObjectsHashTable];
        _isPaused = NO;
    }
    return self;
}

- (void)setDataBundleId:(const char *)bundleId {
    // Acknowledged
}

- (void)registerFrameworkListener:(id<UnityFrameworkListener>)listener {
    if (listener) {
        [_listeners addObject:listener];
    }
}

- (void)unregisterFrameworkListener:(id<UnityFrameworkListener>)listener {
    if (listener) {
        [_listeners removeObject:listener];
    }
}

- (void)runEmbeddedWithArgc:(int)argc
                       argv:(char * _Nullable * _Nullable)argv
              appLaunchOpts:(nullable NSDictionary *)opts {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnityReady" object:self];
        
        if (self->_appController.unitySceneLoadedHandler) {
            const char *sceneName = "DefaultScene";
            const int buildIndex = 0;
            const bool isLoaded = true;
            const bool isValid = true;
            self->_appController.unitySceneLoadedHandler(sceneName, &buildIndex, &isLoaded, &isValid);
        }
    });
}

- (nullable UnityAppController *)appController {
    return _appController;
}

- (void)showUnityWindow {
    if (_appController.window) {
        [_appController.window makeKeyAndVisible];
    }
}

- (void)pause:(bool)pause {
    _isPaused = pause;
}

- (void)unloadApplication {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotification *note = [NSNotification notificationWithName:@"UnityDidUnload" object:self];
        for (id<UnityFrameworkListener> listener in self->_listeners.allObjects) {
            if ([listener respondsToSelector:@selector(unityDidUnload:)]) {
                [listener unityDidUnload:note];
            }
        }
    });
}

- (void)quitApplication:(int)exitCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotification *note = [NSNotification notificationWithName:@"UnityDidQuit" object:self];
        for (id<UnityFrameworkListener> listener in self->_listeners.allObjects) {
            if ([listener respondsToSelector:@selector(unityDidQuit:)]) {
                [listener unityDidQuit:note];
            }
        }
    });
}

- (void)sendMessageToGOWithName:(const char * _Nullable)goName
                   functionName:(const char * _Nullable)funcName
                        message:(const char * _Nullable)msg {
    // Handled
}

@end
