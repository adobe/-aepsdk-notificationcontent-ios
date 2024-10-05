Pod::Spec.new do |s|
    s.name         = "AEPSwiftUI"
    s.version      = "5.1.0"
    s.summary      = "AEPSwiftUI library for Adobe Experience Cloud SDK. Written and maintained by Adobe."
    s.description  = <<-DESC
                     The AEPSwiftUI library provides SwiftUI components for use with AEP SDK extensions.
                     DESC
  
    s.homepage     = "https://github.com/adobe/aepsdk-ui-ios.git"
    s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
    s.author       = "Adobe Experience Platform SDK Team"
    s.source       = { :git => 'https://github.com/adobe/aepsdk-ui-ios.git', :tag => s.version.to_s }
    
    s.platform = :ios, "15.0"
    s.swift_version = '5.1'
  
    s.pod_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }
  
    s.source_files = 'Frameworks/AEPSwiftUI/Sources/**/*.swift'

    s.dependency 'AEPMessaging', '>= 5.3.0', '< 6.0.0'

  end