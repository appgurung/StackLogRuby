# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
version = File.open("lib/stacklog/version.rb").read.scan(/"([^"]*)"/).first.first

Gem::Specification.new do |spec|
  spec.name = "stacklog"
  spec.version = version
  spec.authors       = "Djangod"
  spec.email         = "apps+rubygems@stacklog.io"
  spec.summary       = "StackLog Ruby logger"
  spec.homepage      = "https://github.com/appgurung/StackLogRuby"
  spec.license       = "MIT"
  spec.files         = Dir.glob("{lib}/**/*.rb") + %w[LICENSE README.md]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "concurrent-ruby", "~> 1.0"
  spec.add_runtime_dependency "json", "~> 2.0"
  spec.add_runtime_dependency "require_all", "~> 1.4"
  spec.add_development_dependency "rubocop", "~> 0.78"
end
