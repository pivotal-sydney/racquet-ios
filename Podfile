source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.2'
use_frameworks!

target 'racquet-ios' do
  pod 'Alamofire', '~> 3.0'
  pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
  pod 'Alamofire-SwiftyJSON', :podspec => 'https://raw.githubusercontent.com/pdutourgeerling/Alamofire-SwiftyJSON-Podspec/master/Alamofire3-SwiftyJSON.podspec'
  pod 'HanekeSwift'
end

def testing_pods
  pod 'Quick', '~> 0.9.0'
  pod 'Nimble', '3.0.0'
end

target 'racquet-iosTests' do
  testing_pods
end

target 'racquet-iosUITests' do
  testing_pods
end

