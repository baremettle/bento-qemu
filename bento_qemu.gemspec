# -*- encoding: utf-8 -*-

require File.expand_path('../lib/bento_qemu/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'bento_qemu'
  gem.version       = BentoQemu::VERSION
  gem.summary       = %q(TODO: Summary)
  gem.description   = %q(TODO: Description)
  gem.license       = 'MIT'
  gem.authors       = ['Brian Clark']
  gem.email         = 'brian@clark.zone'
  gem.homepage      = 'https://github.com/bclarkindy/bento_qemu#readme'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
end