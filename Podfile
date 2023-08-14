platform :ios, '11.0'

target 'Demo' do
  use_frameworks!  :linkage => :static
  pod 'ARCore/AugmentedFaces', '~> 1.33.0'
  pod 'CHCSVParser', :inhibit_warnings => true
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # exclude building for arm64 simulators for M1 Macs
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
