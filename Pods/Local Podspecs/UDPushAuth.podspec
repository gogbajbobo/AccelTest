Pod::Spec.new do |s|
  s.name         = "UDPushAuth"
  s.version      = "0.2.1"
  s.summary      = "OAuth-like authorization with apple pushnotifications as a transport for auth_code."
  s.homepage     = "https://github.com/Unact/UDPushAuth"

  s.license      = 'MIT'
  s.author       = { "Vlad Kovtash" => "v.kovtash@gmail.com" }
  s.source       = { :git => "https://github.com/Unact/UDPushAuth.git"}

  s.platform     = :ios, '5.0'
  s.requires_arc = true
  s.source_files = 'pushauth/Classes/**/*.{h,m}'
  
  s.dependency 'Reachability', '~> 3.1.0'
  s.dependency 'GData', '~> 1.9.1'
end
