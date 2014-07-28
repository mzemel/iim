# encoding: utf-8

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

Gem::Specification.new do |s|
  s.name        = 'Incremental Interquartile Mean'
  s.version     = '1.0'
  s.summary     = 'Calculate the incremental interquartile mean (IIM) of data'

  s.description = <<-DESCRIPTION
  Incremental interquartile mean generator
  DESCRIPTION

  s.authors    = 'Michael Zemel'
  s.email       = 'michael.zemel@gmail.com'
  s.license     = 'MIT'
  s.homepage    = 'http://github.com/mzemel/iim'

  s.files       = `git ls-files`.split($/)
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split($/)
  s.executables = s.files.grep(/^bin\//) { |f| File.basename(f) }

  s.require_paths = ['lib']

  # dependencies
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'ruby-vips'
  s.add_development_dependency 'miro'
end
