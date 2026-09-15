#import <Foundation/Foundation.h>

@protocol NativeCallsProtocol
@required
- (void)sendMessageToMobileApp:(NSString *)message;
@end

__attribute__ ((visibility("default")))
@interface FrameworkLibAPI : NSObject
// call it any time after UnityFramework is loaded to set object implementing NativeCallsProtocol methods
+ (void)registerAPIforNativeCalls:(id<NativeCallsProtocol>)aApi;
@end