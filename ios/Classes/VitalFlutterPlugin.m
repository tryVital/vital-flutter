#import "VitalFlutterPlugin.h"
#if __has_include(<vital_flutter/vital_flutter-Swift.h>)
#import <vital_flutter/vital_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vital_flutter-Swift.h"
#endif

@implementation VitalFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVitalFlutterPlugin registerWithRegistrar:registrar];
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVitalFlutterPlugin registerWithRegistrar:registrar];
}

@end
