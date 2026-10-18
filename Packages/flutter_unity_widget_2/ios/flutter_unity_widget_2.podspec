#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_unity_widget_2.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_unity_widget_2'
  s.version          = '4.0.0'
  s.summary          = 'Flutter unity 3D widget stub'
  s.description      = 'No-op stub for flutter_unity_widget_2 without UnityFramework dependency'
  s.homepage         = 'http://xraph.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rex Isaac Raphael' => 'rex.raphael@outlook.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform         = :ios, '12.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version    = '5.0'

  s.resource_bundles = {'flutter_unity_widget_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
