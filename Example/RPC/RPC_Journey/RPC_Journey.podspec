# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RPC_Journey'
  s.version          = '0.0.1'
  s.summary          = 'Auto created sub interfaces from RPC'

  s.description      = <<-DESC
Auto created sub interfaces from RPC, you MUST add RPC_Journey in main proj directroy.
DESC

  s.homepage         = 'https://github.com/darkThanBlack/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'moonShadow' => 'moonshadow_5566@qq.com' }
  s.source           = { :git => 'https://github.com/darkThanBlack/swing-rpc.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/darkThanBlack/'

  s.ios.deployment_target = '12.0'
  s.swift_versions = '5.0'
  s.source_files = 'enumtype/**/*.swift', 'model/**/*.swift', 'service/**/*.swift'
  
  s.dependency 'RPC_Common'
end
