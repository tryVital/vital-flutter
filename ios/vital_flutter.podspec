#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint vital_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'vital_flutter'
  s.version          = '0.0.10'
  s.summary          = 'The official Flutter Plugin for Vital HealthKit'
  s.homepage         = 'https://github.com/tryVital/vital-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Vital' => 'developers@tryVital.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'VitalHealthKit', '~> 0.5.7'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
