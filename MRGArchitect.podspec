Pod::Spec.new do |s|
  s.name             = "MRGArchitect"
  s.version          = "1.0.1"
  s.summary          = "Static application configuration via JSON."
  s.homepage         = "https://github.com/Mirego/MRGDateFormatter"
  s.license          = 'BSD 3-Clause'
  s.authors          = { 'Mirego, Inc.' => 'info@mirego.com' }
  s.source           = { :git => "https://github.com/Mirego/MRGArchitect.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Mirego'

  s.source_files     = 'Pod/Classes'
  s.requires_arc     = true

  s.ios.deployment_target = '6.0'
  s.tvos.deployment_target = '9.0'
end
