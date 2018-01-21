# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
inhibit_all_warnings!

use_frameworks!

def share_pods
  pod 'SnapKit', '~> 4.0.0'
  pod 'SVProgressHUD', '~> 2.1.2'
  pod 'UITextView+Placeholder', '~> 1.2.0'
  pod 'Mantle', '~> 2.1.0'
  pod 'UIColor+Additions', '~> 2.0.2'
  pod 'MBProgressHUD', '~> 1.0.0'
  pod 'DateTools', '~> 2.0.0'
  pod 'CBStoreHouseRefreshControl', '~> 1.0'
  pod 'YYWebImage', '~> 1.0.5'
  pod 'VTMagic', '~> 1.2.4'
  pod 'Texture', '>= 2.0'
  pod 'Then'
  pod 'SwiftyJSON', '~> 3.1.4'
  pod 'ReactiveCocoa', '~> 7.0'
  pod 'JYCarousel', '~> 0.0.3'
  pod 'SwiftyAttributes', '~> 4.1.0'
end

target 'th-ios' do
  share_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = ‘4.0’
    end
  end
end
