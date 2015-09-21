Pod::Spec.new do |s|
  s.name             = "MRGArchitect"
  s.version          = "1.0"
  s.summary          = "Static application configuration via JSON."
  s.homepage         = "https://github.com/Mirego/MRGDateFormatter"
  s.license          = 'BSD 3-Clause'
  s.authors          = { 'Mirego, Inc.' => 'info@mirego.com' }
  s.source           = { :git => "https://github.com/Mirego/MRGArchitect.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Mirego'

  s.platform         = :ios, '6.0'
  s.requires_arc     = true

  s.source_files     = 'Pod/Classes'
end
