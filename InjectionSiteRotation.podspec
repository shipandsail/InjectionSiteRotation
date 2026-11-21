Pod::Spec.new do |s|
  s.name             = 'InjectionSiteRotation'
  s.version          = '1.0.0'
  s.summary          = 'Track subcutaneous injection sites and suggest the next one to rotate to.'
  s.description      = 'A tiny Swift library for apps that log weekly or daily injections (insulin pens, GLP-1 pens and similar): six body sites (abdomen, thighs, upper arms, left and right), least-recently-used rotation with area/side tie-breaking, and days since each site was used. Logging and rotation only; it never recommends or calculates doses.'
  s.homepage         = 'https://bluedoseapp.com/features/injection-site-rotation-app/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alex Bell' => 'strawbelly.app@gmail.com' }
  s.source           = { :git => 'https://github.com/shipandsail/InjectionSiteRotation.git', :tag => s.version.to_s }
  s.swift_versions   = ['5.7']
  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'
  s.watchos.deployment_target = '9.0'
  s.source_files     = 'Sources/InjectionSiteRotation/**/*.swift'
end
