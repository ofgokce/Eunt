Pod::Spec.new do |spec|

  spec.name                     = 'Eunt'
  
  spec.version                  = '1.0.0'
  
  spec.summary                  = 'Routing for UIKit made easy'
  
  spec.homepage                 = 'https://github.com/ofgokce/Eunt'
  
  spec.license                  = { :type => 'MIT', :file => 'LICENSE' }
  
  spec.author                   = { 'Ömer Faruk Gökce' => 'mail@ofgokce.com' }
  
  spec.source                   = { :git => 'https://github.com/ofgokce/Eunt.git', :tag => spec.version.to_s }
  
  spec.social_media_url         = 'https://linkedin.com/in/ofgokce/'
  
  spec.swift_version            = '5.5'

  spec.ios.deployment_target    = '13.0'

  spec.source_files             = 'Sources/Eunt/**/*'
  
end
