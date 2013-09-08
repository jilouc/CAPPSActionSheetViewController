Pod::Spec.new do |s|
  s.name = 'CAPPSActionSheetViewController'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'Action sheets as view controllers, iOS7 styled.'
  s.homepage = 'https://github.com/jilouc/CAPPSActionSheetViewController'
  s.authors = { 'Jean-Luc Dagon' => 'jldagon@cocoapps.fr'}
  s.source = { :git => 'https://github.com/jilouc/CAPPSActionSheetViewController.git', :tag => '1.0' }
  s.source_files = '*.{h,m}'

  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.ios.frameworks = 'QuartzCore'

end
