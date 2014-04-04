Pod::Spec.new do |s|
  s.name     = 'MRGArchitect'
  s.version  = '0.2.0'
  s.license  = 'BSD 3-Clause'
  s.summary  = 'Static application configuration via JSON'
  s.homepage = 'https://github.com/mirego/MRGArchitect'
  s.authors  = { 'Mirego, Inc.' => 'info@mirego.com' }
  s.source   = { :git => 'https://github.com/mirego/MRGArchitect.git', :tag => s.version.to_s }
  s.source_files = 'MRGArchitect/*.{h,m}'
  s.requires_arc = true
  s.platform = :ios, '6.0'
end
