Pod::Spec.new do |spec|

    spec.name              = 'catalyze-ios-sdk'
    spec.version           = '2.4'
    spec.summary           = 'SDK for interacting with the Catalyze API'
    spec.homepage          = 'https://github.com/catalyzeio/catalyze-ios-sdk'
    spec.license           = {
        :type => 'Apache License, Version 2.0',
        :file => 'LICENSE'
    }
    spec.author            = {
        'Josh Ault' => 'josh@catalyze.io'
    }
    spec.source            = {
        :git => 'https://github.com/catalyzeio/catalyze-ios-sdk.git',
        :tag => 'v'+spec.version.to_s
    }
    spec.source_files      = 'catalyze-ios-sdk/*.{m,h}'
    spec.requires_arc      = true
    spec.platform = :ios, '7.0'
    spec.dependency 'AFNetworking', '~> 2.2'
    spec.subspec 'logging' do |ss|
        ss.dependency 'AFNetworkActivityLogger', '~> 2.0'
    end
end