lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'backframe/version'

Gem::Specification.new do |gem|
  gem.name          = 'backframe'
  gem.email         = 'hello@thinktopography.com'
  gem.description   = 'Rails bindings for Reframe'
  gem.version       = Backframe::VERSION
  gem.summary       = 'Backframe'
  gem.authors       = ['Greg Kops', 'Scott Nelson']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'write_xlsx', '~> 0.83.0'
  gem.add_runtime_dependency 'phony', '~> 2.15.21'
  gem.add_runtime_dependency 'activerecord', '~> 4.0'
  gem.add_runtime_dependency 'activesupport', '~> 4.0'
  gem.add_runtime_dependency 'active_model_serializers', '>= 0.10.0.rc4'
  gem.add_runtime_dependency 'kaminari', '~> 0.16'
end
