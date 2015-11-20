# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'module_shims/version'

Gem::Specification.new do |spec|
  spec.name          = "module_shims"
  spec.version       = ModuleShims::VERSION
  spec.authors       = ["Yunpeng Xing (Rick)"]
  spec.email         = ["ypxing@gmail.com"]

  spec.summary       = %q{Insert shims among inheritance chain for debugging/development and reading source code purpose.}
  spec.description   = %q{The gem is one tool used for debugging/developing and as one helper for reading/trying source code of projects (like Ruby on Rails). It helps you prepend modules in the inheritance chain so that you can easily implement your own methods to override existing ones in specific modules/classes without impacting others. Different from monkey patch, you can easily enable/dsiable your implementation.}
  spec.homepage      = "https://github.com/ypxing/module_shims"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
