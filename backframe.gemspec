lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'backframe/version'

Gem::Specification.new do |gem|
  gem.name          = 'backframe'
  gem.email         = 'greg@thinktopography.com'
  gem.description   = 'A collection of core objects for writing testable APIs'
  gem.homepage      = 'https://github.com/thinktopography/backframe'
  gem.version       = Backframe::VERSION
  gem.summary       = 'backframe'
  gem.authors       = ['Greg Kops']
  gem.files         = `git ls-files`.split($/)
  gem.license       = 'MIT'
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rake'
  gem.add_runtime_dependency 'activesupport', '~> 4.0'
  gem.add_runtime_dependency 'activerecord', '~> 4.2'
  gem.add_runtime_dependency 'active_model_serializers', '~> 0.10.0'
  gem.add_runtime_dependency 'write_xlsx', '~> 0.83.0'
end
