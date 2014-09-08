MRuby::Gem::Specification.new('mruby-fileutils-simple') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Alexander Gromnitsky'
  spec.version = '0.0.1'
  spec.summary = 'Like FileUtils but delegates all work to system tools.'
  spec.homepage = 'https://github.com/gromnitsky/mruby-fileutils-simple'

  spec.add_dependency 'mruby-dir'
  spec.add_dependency 'mruby-io'
  spec.add_dependency 'mruby-process'
end
