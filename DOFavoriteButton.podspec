Pod::Spec.new do |s|
  s.name         = "DOFavoriteButton"
  s.version      = "0.0.2"
  s.summary      = "Cute Animated Button written in Swift. It could be just right for favorite buttons!"
  s.homepage     = "https://github.com/okmr-d/DOFavoriteButton"
  s.screenshots  = "https://raw.githubusercontent.com/okmr-d/okmr-d.github.io/master/img/DOFavoriteButton/demo.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Daiki Okumura" => "daiki.okumura@gmail.com" }
  s.platform     = :osx, "10.10"
  s.source       = { :git => "https://github.com/okmr-d/DOFavoriteButton.git", :tag => s.version.to_s }
  s.source_files = "DOFavoriteButton/*.swift"
  s.resources    = "DOFavoriteButton/*.png"
  s.framework    = "AppKit"
  s.requires_arc = true
end
