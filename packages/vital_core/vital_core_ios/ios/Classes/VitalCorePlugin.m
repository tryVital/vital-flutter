#import "VitalCorePlugin.h"
#if __has_include(<vital_core_ios/vital_core_ios-Swift.h>)
#import <vital_core_ios/vital_core_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vital_core_ios-Swift.h"
#endif

@implementation VitalCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVitalCorePlugin registerWithRegistrar:registrar];
}
@end
