Pod::Spec.new do |s|
  s.name             = "Analytics"
  s.version          = "4.0.0-beta.0"
  s.summary          = "The hassle-free way to add analytics to your iOS app."

  s.description      = <<-DESC
                       Analytics for iOS provides a single API that lets you
                       integrate with over 100s of tools.
                       DESC

  s.homepage         = "http://segment.com/"
  s.license          =  { :type => 'MIT' }
  s.author           = { "Segment" => "friends@segment.com" }
  s.source           = { :git => "https://github.com/segmentio/analytics-ios.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/segment'

  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.13'

  s.ios.frameworks = 'CoreTelephony', 'UIKit'
  s.frameworks = 'Security', 'StoreKit', 'SystemConfiguration'

  s.source_files = [
    'Analytics/Classes/**/*',
    'Analytics/Vendor/**/*'
  ]
end
