Pod::Spec.new do |s|
  s.name             = 'EmpowerCustomAdapter'
  s.version          = '1.0.3'
  s.summary          = 'EmpowerCustomAdapter for displaying ads from Empower.'
  s.description      = <<-DESC
Empower Custom Adapter for displaying ads from Empower
                       DESC

  s.homepage         = 'https://github.com/empowernet/EMACustomAdapter.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Noktacom Medya' => 'senaaltun@nokta.com' }
  s.source           = { :git => 'https://github.com/empowernet/EMACustomAdapter.git', :tag => '1.0.3' }
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'EmpowerCustomAdapter/Classes/**/*.swift'
  s.frameworks = 'Foundation'
  s.dependency  'Google-Mobile-Ads-SDK'
  s.static_framework = true
  
end
