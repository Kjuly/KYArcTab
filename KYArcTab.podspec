Pod::Spec.new do |s|
  s.name             = "KYArcTab"
  s.version          = "1.2.2"
  s.summary          = "Arcuated tab view controller with toggleing animation."
  s.description      = <<-DESC
                       Arcuated tab view controller with toggleing animation, 2 ~ 4 tabs are enabled. What's more, you can swipe left or right to toggle the views.
                       DESC
  s.homepage         = "https://github.com/Kjuly/KYArcTab"
  s.license          = 'MIT'
  s.author           = { "Kaijie Yu" => "dev@kjuly.com" }
  s.source           = { :git => "https://github.com/Kjuly/KYArcTab.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'KYArcTab'

  s.frameworks = 'UIKit', 'CoreGraphics', 'QuartzCore'
end

