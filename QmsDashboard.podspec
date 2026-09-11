Pod::Spec.new do |s|
  s.name             = 'QmsDashboard'
  s.version          = '0.1.7'
  s.summary          = 'A short description of QmsDashboard.'
  s.description      = 'QMS Dashboard description'

  s.homepage         = 'https://github.com/NativeSdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Quick Bird' => 'mascot@quickbirdstudios.com' }
  s.source           = {   :git => 'https://github.com/weihan-ng/WH_Plugin_Test.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/QmsDashboard/**/*.swift'
  s.vendored_frameworks = 'Frameworks/QmsPluginFramework.xcframework'
  s.frameworks = 'UIKit', 'Foundation'
end