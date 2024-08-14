#
# Be sure to run `pod lib lint DTBKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DTBKit'
  s.version          = '0.0.1'
  s.summary          = 'A personal bundle kit for best practices. '

  s.description      = <<-DESC
A personal bundle kit for best practices, provides namespace isolation, utility classes and other examples.
DESC

  s.homepage         = 'https://github.com/darkThanBlack/DTBKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'moonShadow' => 'moonshadow_5566@qq.com' }
  s.source           = { :git => 'https://github.com/darkThanBlack/DTBKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://darkthanblack.github.io/'

  s.ios.deployment_target = '12.0'
  s.swift_versions = '5.0'
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'DTBKit/Core/**/*'
  end
  
  s.subspec 'Chain' do |ss|
    ss.source_files = 'DTBKit/Chain/DTBKit+Chain.swift', 'DTBKit/Chain/Foundation/**/*'
    ss.dependency 'DTBKit/Core'
  end
  
  s.subspec 'Basic' do |ss|
    ss.source_files = 'DTBKit/DTBKit.swift', 'DTBKit/Basic/**/*'
    ss.resource_bundles = {
      'DTBKit-Basic' => ['DTBKit/Assets/basic.xcassets']
    }
    ss.dependency 'DTBKit/Chain'
    
    ss.test_spec 'Tests' do |t|
      t.framework = 'XCTest'
      t.requires_app_host = false
      t.source_files = 'DTBKit/Tests/**/*'
    end
  end
  
  s.subspec 'UIKit' do |ss|
    ss.source_files = 'DTBKit/UIKit/**/*'
    ss.resource_bundles = {
      'DTBKit-UIKit' => ['DTBKit/Assets/ui-kit.xcassets']
    }
    ss.dependency 'DTBKit/Basic'
    # ss.dependency 'SnapKit', '5.0.1'
  end
  
  s.subspec 'Map' do |ss|
    ss.source_files = 'DTBKit/Map/**/*'
    ss.dependency 'DTBKit/Basic'
  end
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
