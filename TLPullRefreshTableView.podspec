Pod::Spec.new do |s|  
  s.name             = "TLPullRefreshTableView"  
  s.version          = "1.0.0"  
  s.summary          = "a PullRefreshTable which can custom refresh style."  
  s.description      = <<-DESC  
                       a PullRefreshTable which can custom refresh style.  
                       DESC  
  s.homepage         = "https://github.com/wangzz/WZMarqueeView"  
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"  
  s.license          = 'MIT'  
  s.author           = { "Creolophus" => "" }  
  s.source           = { :git => "https://github.com/Creolophus/TLPullRefreshTableView.git", :tag => s.version.to_s }  
  # s.social_media_url = 'https://twitter.com/NAME'  
  
  s.platform     = :ios, '5.0'  
  # s.ios.deployment_target = '5.0'  

  s.requires_arc = true  
  
  s.source_files = 'TLPullRefreshTableView/*'  
  # s.resources = 'Assets'  
  
  # s.ios.exclude_files = 'Classes/osx'  
  # s.osx.exclude_files = 'Classes/ios'  
  # s.public_header_files = 'Classes/**/*.h'  
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'  
  
end  