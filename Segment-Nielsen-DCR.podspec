Pod::Spec.new do |s|
  s.name             = 'Segment-Nielsen-DCR'
  s.version          = '1.3.3'
  s.summary          = "Nielsen DCR Integration for Segment's analytics-ios library."

  s.description      = <<-DESC
  Analytics for iOS provides a single API that lets you
  integrate with over 100s of tools.

  This is the Nielsen integration for the iOS library.
                       DESC

  s.homepage         = 'http://segment.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Segment' => 'friends@segment.com' }
  s.source           = { :git => 'https://github.com/segment-integrations/analytics-ios-integration-nielsen-dcr.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/segment'

  s.ios.deployment_target = '10.0'
  s.source_files = 'Segment-Nielsen-DCR/Classes/**/*.{h,m}'
  s.preserve_paths = 'Segment-Nielsen-DCR/Classes/**/*'

  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 i386' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 i386' }

  s.dependency 'Analytics'
  s.dependency 'NielsenAppSDK', '~> 8.0'

end
