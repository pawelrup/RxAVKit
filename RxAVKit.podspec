Pod::Spec.new do |s|
  s.name             = 'RxAVKit'
  s.version          = '1.1.0'
  s.summary          = 'Rx extension for AVKit.'

  s.description      = <<-DESC
  Rx extension for AVKit.
  Requires Xcode 11.0 with Swift 5.1.
                       DESC

  s.homepage         = 'https://github.com/pawelrup/RxAVKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paweł Rup' => 'pawelrup@lobocode.pl' }
  s.source           = { :git => 'https://github.com/pawelrup/RxAVKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'

  s.swift_version = '5.1'
  s.pod_target_xcconfig =  {
    'SWIFT_VERSION' => '5.1',
  }

  s.source_files = 'Sources/RxAVKit/**/*'

  s.frameworks = 'AVKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
