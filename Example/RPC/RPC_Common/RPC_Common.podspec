# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RPC_Common'
  s.version          = '0.0.1'
  s.summary          = 'Auto created codes from RPC'

  s.description      = <<-DESC
Auto created codes from RPC, see swing-RPC proj to learn more.
DESC

  s.homepage         = 'https://github.com/darkThanBlack/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'moonShadow' => 'moonshadow_5566@qq.com' }
  s.source           = { :git => 'https://github.com/darkThanBlack/swing-rpc.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/darkThanBlack/'

  s.ios.deployment_target = '12.0'
  s.swift_versions = '5.0'
  s.source_files = 'depends/**/*.swift', 'enumtype/**/*.swift', 'model/**/*.swift', 'service/**.*.swift'

#  s.dependency 'Moya'
#  s.dependency 'ObjectMapper'

  s.dependency 'Moya'
  # 提供额外的 Transform
  s.dependency 'DTBKit/ObjectMapper'
  
end
