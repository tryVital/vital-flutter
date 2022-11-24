#import "VitalHealthPlugin.h"
#if __has_include(<vital_health_ios/vital_health_ios-Swift.h>)
#import <vital_health_ios/vital_health_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vital_health_ios-Swift.h"
#endif

@implementation VitalHealthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVitalHealthKitPlugin registerWithRegistrar:registrar];
  [SwiftVitalDevicesPlugin registerWithRegistrar:registrar];
}
@end
