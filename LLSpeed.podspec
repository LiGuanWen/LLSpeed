#
#  Be sure to run `pod spec lint HePaiPay.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LLSpeed"
  s.version      = "1.0.0"
  s.summary      = "use for Lilong LLSpeed module."
  s.description  = <<-DESC
		   use for LLSpeed module.
		   It’s awesome!!
                   DESC

  s.homepage     = "https://github.com/LiGuanWen/LLSpeed"
  s.license      = "MIT"
  s.author       = { "Lilong" => "diqidaimu@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LiGuanWen/LLSpeed.git", :branch => "#{s.version}" }
  s.source_files  = "LLSpeedClass/**/*.{h,m,mm,a,framework}","LLSpeedClass/LLSpeedPrefixHeader.pch"
  s.resources    = "LLSpeedClass/**/*.xib","LLSpeedClass/**/*.bundle","LLSpeedClass/**/*.xcassets"
  # s.prefix_header_file = 'LLDBClass/LLBuyPrefixHeader.pch'    #PCH文件
  
  #s.vendored_frameworks = "HePaiClub/util/thirdpart/Alipay/AlipaySDK.framework"
  #s.frameworks  = "AlipaySDK"
  #s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/HePaiPay/HePaiPay/util/thirdpart/Alipay/' }
  #s.frameworks = "HePaiPay/**/*.{h,m,a,framework}"
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"
  # s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  #s.dependency "AFNetworking"
  # s.dependency "LLKit", "~> 1.0.0"
  # s.dependency "WCDB"
end
