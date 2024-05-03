Pod::Spec.new do |s|
    s.name             = 'Keemun'
    s.version          = '2.0.0-beta02'
    s.summary          = 'Swift the Elm architecture pattern'
    s.description      = <<-DESC
    Swift framework that provides a way to write code using The Elm Architecture pattern.
    DESC
    s.homepage         = 'https://github.com/pavelannin/Keemun-Swift'
    s.license          = 'Apache License 2.0'
    s.author           = { 'Pavel Annin' => 'pavelannin.dev@gmail.com' }
    s.source           = { :git => 'https://github.com/pavelannin/Keemun-Swift.git', :tag => s.version.to_s }
    s.homepage         = 'https://github.com/pavelannin/Keemun-Swift'

    s.ios.deployment_target = '13.0'

    s.source_files = 'Sources/KeemunSwift/**/*.swift'
    s.swift_versions = ['5.7', '5.8', '5.9']
end
