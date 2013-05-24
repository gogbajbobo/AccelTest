Pod::Spec.new do |s|
  s.name         = "STManagedTracker"
  s.version      = "0.0.1"
  s.summary      = "Sys-team STManagedTracker."

  s.homepage     = "https://github.com/sys-team/STManagedTracker"

  s.license      = 'MIT'

  s.author       = { "Grigoriev Maxim" => "grigoriev.maxim@gmail.com" }

  s.source       = { :git => "https://github.com/sys-team/STManagedTracker.git", :branch => 'master'}

  s.platform     = :ios, '5.0'


  s.source_files = 'STManagedTracker/Classes/ST*.{h,m}', 'STManagedTracker/DataModel/ST*.{h,m}', 'STManagedTracker/Protocols/ST*.{h,m}'

  s.resources = 'STManagedTracker/DataModel/ST*.{xcdatamodel,xcdatamodeld}'

  s.frameworks = 'SystemConfiguration', 'CoreData', 'CoreLocation', 'UIKit', 'Foundation', 'CoreGraphics'

  s.requires_arc = true

#  s.dependency 'UDPushAuth', :git => 'https://github.com/Unact/UDPushAuth.git', :branch => 'master'

end
