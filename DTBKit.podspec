#
# Be sure to run `pod lib lint DTBKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DTBKit'
  s.version          = '0.1.0'
  s.summary          = 'A personal bundle kit for best practices.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A personal bundle kit for best practices.
                       DESC

  s.homepage         = 'https://github.com/moonShadow/DTBKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'moonShadow' => 'moonshadow_5566@qq.com' }
  s.source           = { :git => 'https://github.com/moonShadow/DTBKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://darkthanblack.github.io/'

  s.ios.deployment_target = '11.0'

  # s.source_files = 'DTBKit/DTBKit.swift'
  
  # s.resource_bundles = {
  #   'DTBKit' => ['DTBKit/Assets/*.xcassets']
  # }
  
  # s.test_spec 'Tests' do |t|
  #   t.framework = 'XCTest'
  #   t.source_files = 'DTBKit/Tests/**/*'
  # end
  
  s.subspec 'Basic' do |ss|
    ss.source_files = 'DTBKit/DTBKit.swift', 'DTBKit/Basic/**/*'
    ss.resource_bundles = {
      'DTBKit-Basic' => ['DTBKit/Assets/basic.xcassets']
    }
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
