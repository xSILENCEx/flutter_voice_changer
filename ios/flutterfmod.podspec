#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutterfmod.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutterfmod'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.license          = 'MIT'
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'fmod/inc/*'
  s.public_header_files = 'Classes/**/*.h', 'fmod/**/*.h'
  s.vendored_libraries = "fmod/lib/*.a", 'recordamr/*.a'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.library = 'c++'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
