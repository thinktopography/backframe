lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'backframe/version'

Gem::Specification.new do |gem|
  gem.name          = 'backframe'
  gem.version       = Backframe::VERSION
  gem.summary       = 'backframe'
  gem.authors       = ['Greg Kops']
  gem.files         = ["lib/*.rb"]
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rake'
  gem.add_runtime_dependency 'activesupport', '~> 4.0'
  gem.add_runtime_dependency 'active_model_serializers', '~> 0.8.3'
  gem.add_runtime_dependency 'write_xlsx', '~> 0.83.0'
end
