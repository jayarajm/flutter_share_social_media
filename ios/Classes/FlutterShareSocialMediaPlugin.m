#import "FlutterShareSocialMediaPlugin.h"
#import <flutter_share_social_media/flutter_share_social_media-Swift.h>

@implementation FlutterShareSocialMediaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterShareSocialMediaPlugin registerWithRegistrar:registrar];
}
@end
