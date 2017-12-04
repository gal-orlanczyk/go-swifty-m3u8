
Pod::Spec.new do |s|
  s.name         = "GoSwiftyM3U8"
  s.version      = "1.0.0"
  s.summary      = "GoSwiftyM3U8 is a framework used for parsing and handling .m3u8 files"
  s.description  = <<-DESC 
                   GoSwiftyM3U8 is used to parse and handle .m3u8 files.
                   It also allows altering the original text of playlists.
                   DESC
  s.homepage     = "https://github.com/gal-orlanczyk/go-swifty-m3u8"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Gal Orlanczyk" => "gal.orlanczyk@outlook.com" }
  
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"
  
  s.source = { :git => "https://github.com/gal-orlanczyk/go-swifty-m3u8.git", :tag => s.version.to_s }
  s.source_files = 'Sources/**/*.swift'
end
