#include "RegisterFeatures.h"
#include <csignal>
#include "UnityInterface.h"
#import <UnityFramework/UnityFramework.h>
#import <Foundation/Foundation.h>
#include "UI/Keyboard.h"

void UnityInitTrampoline();

// WARNING: this MUST be c decl (NSString ctor will be called after +load, so we cant really change its value)
const char* AppControllerClassName = "UnityAppController";

extern "C" void UnitySetExecuteMachHeader(const MachHeader* header);

extern "C" __attribute__((visibility("default"))) NSString* const kUnityDidUnload;
extern "C" __attribute__((visibility("default"))) NSString* const kUnityDidQuit;

// IL2CPP and Native declarations for UaaL Interceptor
extern "C" void SceneManager_LoadScene_mC4BD32145437F282CAA13E1A8685001061E79D98(int32_t sceneBuildIndex, int32_t mode, const void* method);
extern "C" void SendMessageToFlutterNative(const char* message);
extern "C" void OnUnitySceneLoaded(const char* name, const int* buildIndex, const bool* isLoaded, const bool* IsValid);
extern "C" void OnUnityMessage(const char* message);

// Canonical 9 compiled scene names in ios/UnityLibrary/Data (level0 .. level8)
static const char* const kGuidoScenes[] = {
    "SplashScreen",          // level0: Splash / initial loader
    "MainMenu Corretto",     // level1: Main Menu
    "Procedimento acqua",    // level2: Water tutorial (71s fixed duration)
    "Respirazione acqua",    // level3: Water continuous meditation (looping)
    "Procedimento aria",     // level4: Air tutorial
    "Respirazione aria",     // level5: Air continuous meditation (looping)
    "Procedimento fuoco",    // level6: Fire tutorial
    "Respirazione fuoco",    // level7: Fire continuous meditation (looping)
    "Procedimento terra"     // level8: Earth meditation / procedural ground
};

static int ResolveGuidoSceneIndex(NSString* sceneIdentifier)
{
    if (!sceneIdentifier || sceneIdentifier.length == 0)
    {
        return 3; // Default: Respirazione acqua (continuous meditation)
    }

    NSString* lower = [sceneIdentifier lowercaseString];

    // Check if integer index directly provided
    NSScanner* scanner = [NSScanner scannerWithString:lower];
    int numericIdx = -1;
    if ([scanner scanInt:&numericIdx] && [scanner isAtEnd])
    {
        if (numericIdx >= 0 && numericIdx <= 8)
        {
            return numericIdx;
        }
    }

    if ([lower containsString:@"splash"])
    {
        return 0; // SplashScreen
    }

    if ([lower containsString:@"menu"] || [lower containsString:@"main"])
    {
        return 1; // MainMenu Corretto
    }

    // 1. AIR / ARIA (Resolved first to prevent false water match)
    if ([lower containsString:@"procedimento"] && ([lower containsString:@"aria"] || [lower containsString:@"air"]))
    {
        return 4; // Procedimento aria (tutorial)
    }
    if ([lower containsString:@"aria"] || [lower containsString:@"air"])
    {
        return 5; // Respirazione aria (continuous meditation)
    }

    // 2. FIRE / FUOCO
    if ([lower containsString:@"procedimento"] && ([lower containsString:@"fuoco"] || [lower containsString:@"fire"]))
    {
        return 6; // Procedimento fuoco (tutorial)
    }
    if ([lower containsString:@"fuoco"] || [lower containsString:@"fire"])
    {
        return 7; // Respirazione fuoco (continuous meditation)
    }

    // 3. EARTH / TERRA
    if ([lower containsString:@"terra"] || [lower containsString:@"earth"] || [lower containsString:@"ground"])
    {
        return 8; // Procedimento terra (earth meditation)
    }

    // 4. WATER / ACQUA
    if ([lower containsString:@"procedimento"] && ([lower containsString:@"acqua"] || [lower containsString:@"water"]))
    {
        return 2; // Procedimento acqua (tutorial 71s)
    }
    if ([lower containsString:@"acqua"] || [lower containsString:@"water"] || [lower containsString:@"alba"] ||
        [lower containsString:@"flow"] || [lower containsString:@"mattin"] || [lower containsString:@"sera"] ||
        [lower containsString:@"riposo"] || [lower containsString:@"calm"] || [lower containsString:@"focus"] ||
        [lower containsString:@"present"] || [lower containsString:@"concentrazione"] ||
        [lower containsString:@"pomeriggio"] || [lower containsString:@"starlight"])
    {
        return 3; // Respirazione acqua (continuous meditation)
    }

    // Default fallback to continuous water meditation
    return 3;
}

static void ExecuteNativeSceneLoad(int buildIndex, const char* customSceneName, double durationSeconds, BOOL isVrMode)
{
    if (buildIndex < 0 || buildIndex > 8)
    {
        buildIndex = 3;
    }

    const char* sceneName = (customSceneName && strlen(customSceneName) > 0) ? customSceneName : kGuidoScenes[buildIndex];

    NSLog(@"[Guido Native Interceptor] >>> Loading Scene [%d]: %s (VR: %d, Duration: %.1fs, Mode: Single)", buildIndex, sceneName, (int)isVrMode, durationSeconds);

    // 1. Native IL2CPP SceneManager invocation with LoadSceneMode.Single (0)
    // LoadSceneMode.Single destroys the previous scene GameObjects, clearing RAM/VRAM
    const int32_t kLoadSceneModeSingle = 0;
    SceneManager_LoadScene_mC4BD32145437F282CAA13E1A8685001061E79D98(buildIndex, kLoadSceneModeSingle, NULL);

    // 2. Fallback UnitySendMessage to SceneLoader / GameObject if present in scene
    char idxBuf[16];
    snprintf(idxBuf, sizeof(idxBuf), "%d", buildIndex);
    UnitySendMessage("SceneLoader", "LoadScene", idxBuf);

    // 3. Forward VR mode configuration to VRStereoCameraRig & FlutterBridgeManager
    const char* vrModeStr = isVrMode ? "1" : "0";
    UnitySendMessage("VRStereoCameraRig", "SetVrModeFromMessage", vrModeStr);
    UnitySendMessage("FlutterBridgeManager", "SetVrModeFromMessage", vrModeStr);

    // 4. Notify Flutter via direct callback handlers
    bool isLoaded = true;
    bool isValid = true;
    OnUnitySceneLoaded(sceneName, &buildIndex, &isLoaded, &isValid);

    // 5. Send RPC confirmation to Flutter
    NSString* rpcResponse = [NSString stringWithFormat:
        @"{\"jsonrpc\":\"2.0\",\"method\":\"onSceneLoaded\",\"params\":\"{\\\"sceneName\\\":\\\"%s\\\",\\\"buildIndex\\\":%d}\",\"id\":1}",
        sceneName, buildIndex];
    SendMessageToFlutterNative([rpcResponse UTF8String]);

    // 6. Emit initial progress event so Flutter heartbeat starts and 10s watchdog cancels
    double totalDuration = durationSeconds > 0 ? durationSeconds : 300.0;
    NSString* progressResponse = [NSString stringWithFormat:
        @"{\"sessionId\":\"sess_%ld\",\"sceneName\":\"%s\",\"elapsedSeconds\":0.0,\"totalDurationSeconds\":%.1f,\"progressNormalized\":0.0,\"currentPhase\":\"inhale\",\"userHeartRateOrState\":0}",
        (long)[[NSDate date] timeIntervalSince1970], sceneName, totalDuration];
    SendMessageToFlutterNative([progressResponse UTF8String]);
}

@implementation UnityFramework
{
    int runCount;
}

UnityFramework* _gUnityFramework = nil;
+ (UnityFramework*)getInstance
{
    if (_gUnityFramework == nil)
    {
        _gUnityFramework = [[UnityFramework alloc] init];
    }
    return _gUnityFramework;
}

- (UnityAppController*)appController
{
    return GetAppController();
}

- (UITextField*)keyboardTextField
{
    return KeyboardDelegate.Instance.getTextField;
}

- (void)setExecuteHeader:(const MachHeader*)header
{
    UnitySetExecuteMachHeader(header);
}

- (void)sendMessageToGOWithName:(const char*)goName functionName:(const char*)name message:(const char*)msg
{
    @autoreleasepool
    {
        NSString* goStr = goName ? [NSString stringWithUTF8String:goName] : @"";
        NSString* fnStr = name ? [NSString stringWithUTF8String:name] : @"";
        NSString* msgStr = msg ? [NSString stringWithUTF8String:msg] : @"";

        NSLog(@"[Guido Native Interceptor] Inbound Message -> GO: '%@', Func: '%@', Payload: '%@'", goStr, fnStr, msgStr);

        BOOL intercepted = NO;

        // Check if message is JSON
        id jsonObject = nil;
        if (msgStr.length > 0)
        {
            NSData* data = [msgStr dataUsingEncoding:NSUTF8StringEncoding];
            if (data)
            {
                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            }
        }

        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dict = (NSDictionary*)jsonObject;
            NSString* method = dict[@"method"] ?: dict[@"name"];
            id params = dict[@"params"] ?: dict[@"data"];

            if (method && [method isKindOfClass:[NSString class]])
            {
                NSString* lowerMethod = [method lowercaseString];

                if ([lowerMethod isEqualToString:@"startsession"])
                {
                    intercepted = YES;
                    NSString* sceneName = @"";
                    double durationSeconds = 300.0;
                    BOOL isVrMode = NO;

                    if ([params isKindOfClass:[NSString class]] && ((NSString*)params).length > 0)
                    {
                        NSData* paramData = [((NSString*)params) dataUsingEncoding:NSUTF8StringEncoding];
                        if (paramData)
                        {
                            id paramObj = [NSJSONSerialization JSONObjectWithData:paramData options:0 error:nil];
                            if ([paramObj isKindOfClass:[NSDictionary class]])
                            {
                                NSDictionary* pDict = (NSDictionary*)paramObj;
                                sceneName = pDict[@"sceneName"] ?: @"";
                                durationSeconds = [pDict[@"durationSeconds"] doubleValue];
                                isVrMode = [pDict[@"isVrMode"] boolValue];
                            }
                            else
                            {
                                sceneName = (NSString*)params;
                            }
                        }
                        else
                        {
                            sceneName = (NSString*)params;
                        }
                    }
                    else if ([params isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary* pDict = (NSDictionary*)params;
                        sceneName = pDict[@"sceneName"] ?: @"";
                        durationSeconds = [pDict[@"durationSeconds"] doubleValue];
                        isVrMode = [pDict[@"isVrMode"] boolValue];
                    }

                    int buildIndex = ResolveGuidoSceneIndex(sceneName);
                    ExecuteNativeSceneLoad(buildIndex, [sceneName UTF8String], durationSeconds, isVrMode);
                }
                else if ([lowerMethod isEqualToString:@"loadscene"] || [lowerMethod isEqualToString:@"loadscenebyname"])
                {
                    intercepted = YES;
                    NSString* sceneName = @"";
                    if ([params isKindOfClass:[NSString class]])
                    {
                        sceneName = (NSString*)params;
                    }
                    else if ([params isKindOfClass:[NSDictionary class]])
                    {
                        sceneName = params[@"sceneName"] ?: @"";
                    }

                    int buildIndex = ResolveGuidoSceneIndex(sceneName);
                    ExecuteNativeSceneLoad(buildIndex, [sceneName UTF8String], 300.0, NO);
                }
                else if ([lowerMethod isEqualToString:@"pausesession"])
                {
                    intercepted = YES;
                    UnityPause(1);
                    NSLog(@"[Guido Native Interceptor] Session Paused.");
                }
                else if ([lowerMethod isEqualToString:@"resumesession"])
                {
                    intercepted = YES;
                    UnityPause(0);
                    NSLog(@"[Guido Native Interceptor] Session Resumed.");
                }
                else if ([lowerMethod isEqualToString:@"stopsession"])
                {
                    intercepted = YES;
                    ExecuteNativeSceneLoad(1, "MainMenu Corretto", 0.0, NO);
                    UnityPause(0);
                    NSLog(@"[Guido Native Interceptor] Session Stopped -> MainMenu loaded.");
                }
                else if ([lowerMethod isEqualToString:@"setvrmode"])
                {
                    intercepted = YES;
                    BOOL isVr = NO;
                    if ([params isKindOfClass:[NSNumber class]])
                    {
                        isVr = [params boolValue];
                    }
                    else if ([params isKindOfClass:[NSString class]])
                    {
                        NSString* pStr = (NSString*)params;
                        if ([pStr isEqualToString:@"true"] || [pStr isEqualToString:@"1"])
                        {
                            isVr = YES;
                        }
                        else if ([pStr isEqualToString:@"false"] || [pStr isEqualToString:@"0"])
                        {
                            isVr = NO;
                        }
                        else
                        {
                            NSData* pData = [pStr dataUsingEncoding:NSUTF8StringEncoding];
                            if (pData)
                            {
                                id pObj = [NSJSONSerialization JSONObjectWithData:pData options:0 error:nil];
                                if ([pObj isKindOfClass:[NSDictionary class]])
                                {
                                    isVr = [pObj[@"isVrMode"] boolValue];
                                }
                                else if ([pObj isKindOfClass:[NSNumber class]])
                                {
                                    isVr = [pObj boolValue];
                                }
                            }
                        }
                    }
                    else if ([params isKindOfClass:[NSDictionary class]])
                    {
                        isVr = [params[@"isVrMode"] boolValue];
                    }
                    NSLog(@"[Guido Native Interceptor] SetVrMode: %d", (int)isVr);
                    const char* vrModeStr = isVr ? "1" : "0";
                    UnitySendMessage("VRStereoCameraRig", "SetVrModeFromMessage", vrModeStr);
                    UnitySendMessage("FlutterBridgeManager", "SetVrModeFromMessage", vrModeStr);
                }
                else if ([lowerMethod isEqualToString:@"rotatecamera"])
                {
                    intercepted = YES;
                    float dx = 0.0f;
                    float dy = 0.0f;
                    if ([params isKindOfClass:[NSDictionary class]])
                    {
                        dx = [params[@"dx"] floatValue];
                        dy = [params[@"dy"] floatValue];
                    }
                    else if ([params isKindOfClass:[NSString class]])
                    {
                        NSData* pData = [((NSString*)params) dataUsingEncoding:NSUTF8StringEncoding];
                        if (pData)
                        {
                            id pObj = [NSJSONSerialization JSONObjectWithData:pData options:0 error:nil];
                            if ([pObj isKindOfClass:[NSDictionary class]])
                            {
                                dx = [pObj[@"dx"] floatValue];
                                dy = [pObj[@"dy"] floatValue];
                            }
                        }
                    }
                    NSString* rotPayload = [NSString stringWithFormat:@"{\"dx\":%f,\"dy\":%f}", dx, dy];
                    UnitySendMessage("VRStereoCameraRig", "RotateCameraFromMessage", [rotPayload UTF8String]);
                    UnitySendMessage("FlutterBridgeManager", "RotateCameraFromMessage", [rotPayload UTF8String]);
                }
                else if ([lowerMethod isEqualToString:@"recalibratevr"] || [lowerMethod isEqualToString:@"recalibrate"])
                {
                    intercepted = YES;
                    NSLog(@"[Guido Native Interceptor] Recalibrate VR requested.");
                    UnitySendMessage("VRStereoCameraRig", "RecalibrateFromMessage", "");
                    UnitySendMessage("FlutterBridgeManager", "RecalibrateFromMessage", "");
                }
            }
            else if (dict[@"sceneName"])
            {
                intercepted = YES;
                NSString* sceneName = dict[@"sceneName"];
                double durationSeconds = [dict[@"durationSeconds"] doubleValue];
                BOOL isVrMode = [dict[@"isVrMode"] boolValue];
                int buildIndex = ResolveGuidoSceneIndex(sceneName);
                ExecuteNativeSceneLoad(buildIndex, [sceneName UTF8String], durationSeconds, isVrMode);
            }
        }

        // Direct method call or non-JSON string handling
        if (!intercepted)
        {
            NSString* lowerFn = [fnStr lowercaseString];
            if ([lowerFn isEqualToString:@"loadscene"] || [lowerFn isEqualToString:@"loadscenebyname"])
            {
                int buildIndex = ResolveGuidoSceneIndex(msgStr);
                ExecuteNativeSceneLoad(buildIndex, [msgStr UTF8String], 300.0, NO);
                intercepted = YES;
            }
            else if ([lowerFn isEqualToString:@"startsession"])
            {
                int buildIndex = ResolveGuidoSceneIndex(msgStr);
                ExecuteNativeSceneLoad(buildIndex, [msgStr UTF8String], 300.0, NO);
                intercepted = YES;
            }
            else if ([lowerFn isEqualToString:@"rotatecamera"])
            {
                intercepted = YES;
                UnitySendMessage("VRStereoCameraRig", "RotateCameraFromMessage", [msgStr UTF8String]);
                UnitySendMessage("FlutterBridgeManager", "RotateCameraFromMessage", [msgStr UTF8String]);
            }
            else if ([lowerFn isEqualToString:@"setvrmode"])
            {
                intercepted = YES;
                UnitySendMessage("VRStereoCameraRig", "SetVrModeFromMessage", [msgStr UTF8String]);
                UnitySendMessage("FlutterBridgeManager", "SetVrModeFromMessage", [msgStr UTF8String]);
            }
            else if ([lowerFn isEqualToString:@"recalibratevr"] || [lowerFn isEqualToString:@"recalibrate"])
            {
                intercepted = YES;
                UnitySendMessage("VRStereoCameraRig", "RecalibrateFromMessage", "");
                UnitySendMessage("FlutterBridgeManager", "RecalibrateFromMessage", "");
            }
        }

        // Always invoke standard UnitySendMessage as fallback
        UnitySendMessage(goName, name, msg);
    }
}

- (void)registerFrameworkListener:(id<UnityFrameworkListener>)obj
{
#define REGISTER_SELECTOR(sel, notif_name)                  \
if([obj respondsToSelector:sel])                        \
[[NSNotificationCenter defaultCenter]   addObserver:obj selector:sel name:notif_name object:nil];

    REGISTER_SELECTOR(@selector(unityDidUnload:), kUnityDidUnload);
    REGISTER_SELECTOR(@selector(unityDidQuit:), kUnityDidQuit);

#undef REGISTER_SELECTOR
}

- (void)unregisterFrameworkListener:(id<UnityFrameworkListener>)obj
{
    [[NSNotificationCenter defaultCenter] removeObserver: obj name: kUnityDidUnload object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: obj name: kUnityDidQuit object: nil];
}

- (void)frameworkWarmup:(int)argc argv:(char*[])argv
{
    UnityInitTrampoline();
    UnityInitRuntime(argc, argv);

    RegisterFeatures();

    // iOS terminates open sockets when an application enters background mode.
    // The next write to any of such socket causes SIGPIPE signal being raised,
    // even if the request has been done from scripting side. This disables the
    // signal and allows Mono to throw a proper C# exception.
    std::signal(SIGPIPE, SIG_IGN);
}

- (void)setDataBundleId:(const char*)bundleId
{
    UnitySetDataBundleDirWithBundleId(bundleId);
}

- (void)runUIApplicationMainWithArgc:(int)argc argv:(char*[])argv
{
    self->runCount += 1;
    [self frameworkWarmup: argc argv: argv];
    UIApplicationMain(argc, argv, nil, [NSString stringWithUTF8String: AppControllerClassName]);
}

- (void)runEmbeddedWithArgc:(int)argc argv:(char*[])argv appLaunchOpts:(NSDictionary*)appLaunchOpts
{
    if (self->runCount)
    {
        // initialize from partial unload ( sceneLessMode & onPause )
        UnityLoadApplicationFromSceneLessState();
        UnitySuppressPauseMessage();
        [self pause: false];
        [self showUnityWindow];

        // Send Unity start event
        UnitySendEmbeddedLaunchEvent(0);
    }
    else
    {
        // full initialization from ground up
        [self frameworkWarmup: argc argv: argv];

        id app = [UIApplication sharedApplication];

        id appCtrl = [[NSClassFromString([NSString stringWithUTF8String: AppControllerClassName]) alloc] init];
        [appCtrl application: app didFinishLaunchingWithOptions: appLaunchOpts];

        [appCtrl applicationWillEnterForeground: app];
        [appCtrl applicationDidBecomeActive: app];

        // Send Unity start (first time) event
        UnitySendEmbeddedLaunchEvent(1);
    }

    self->runCount += 1;
}

- (void)unloadApplication
{
    UnityUnloadApplication();
}

- (void)quitApplication:(int)exitCode
{
    UnityQuitApplication(exitCode);
}

- (void)showUnityWindow
{
    [[[self appController] window] makeKeyAndVisible];
}

- (void)pause:(bool)pause
{
    UnityPause(pause);
}

- (void)setAbsoluteURL:(const char *)url
{
    UnitySetAbsoluteURL(url);
}

- (int)shouldRunInBackground
{
    return UnityShouldRunInBackground();
}

@end


#if TARGET_OS_SIMULATOR
#include <pthread.h>

extern "C" int pthread_cond_init$UNIX2003(pthread_cond_t *cond, const pthread_condattr_t *attr)
{ return pthread_cond_init(cond, attr); }
extern "C" int pthread_cond_destroy$UNIX2003(pthread_cond_t *cond)
{ return pthread_cond_destroy(cond); }
extern "C" int pthread_cond_wait$UNIX2003(pthread_cond_t *cond, pthread_mutex_t *mutex)
{ return pthread_cond_wait(cond, mutex); }
extern "C" int pthread_cond_timedwait$UNIX2003(pthread_cond_t *cond, pthread_mutex_t *mutex,
    const struct timespec *abstime)
{ return pthread_cond_timedwait(cond, mutex, abstime); }

#endif // TARGET_OS_SIMULATOR
