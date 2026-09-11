#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UnityFrameworkListener <NSObject>
@optional
- (void)unityDidUnload:(NSNotification *)notification;
- (void)unityDidQuit:(NSNotification *)notification;
@end

@interface UnityAppController : NSObject

@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, copy, nullable) void (^unityMessageHandler)(const char * _Nullable message);
@property (nonatomic, copy, nullable) void (^unitySceneLoadedHandler)(const char * _Nullable name,
                                                                      const int * _Nullable buildIndex,
                                                                      const bool * _Nullable isLoaded,
                                                                      const bool * _Nullable isValid);

- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;

@end

@interface UnityFramework : NSObject

+ (UnityFramework *)getInstance;

- (void)setDataBundleId:(const char *)bundleId;
- (void)registerListener:(id<UnityFrameworkListener>)listener;
- (void)registerFrameworkListener:(id<UnityFrameworkListener>)listener NS_SWIFT_NAME(register(_:));
- (void)unregisterListener:(id<UnityFrameworkListener>)listener;
- (void)unregisterFrameworkListener:(id<UnityFrameworkListener>)listener;

- (void)runEmbeddedWithArgc:(int)argc
                       argv:(char * _Nullable * _Nullable)argv
              appLaunchOpts:(nullable NSDictionary *)opts;

- (nullable UnityAppController *)appController;
- (void)showUnityWindow;
- (void)pause:(bool)pause;
- (void)unloadApplication;
- (void)quitApplication:(int)exitCode;

- (void)sendMessageToGOWithName:(const char *)goName
                   functionName:(const char *)funcName
                        message:(const char *)msg;

@end

NS_ASSUME_NONNULL_END
