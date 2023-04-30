#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint speech_xf.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'speech_xf'
  s.version          = '0.0.1'
  s.summary          = '该插件集成了讯飞语音识别功能。支持Android和IOS平台'
  s.description      = <<-DESC
该插件集成了讯飞语音识别功能。支持Android和IOS平台
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
