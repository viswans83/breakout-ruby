# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'breakout/version'

Gem::Specification.new do |spec|
  spec.name          = "breakout"
  spec.version       = Breakout::VERSION
  spec.authors       = ["Sankaranarayanan Viswanathan"]
  spec.email         = ["rationalrevolt@gmail.com"]
  spec.summary       = %q{The game Breakout aka Bricks made in Ruby using libgosu. A project inspired by The Great Code Club!}
  spec.description   = %q{N/A}
  spec.homepage      = "https://github.com/rationalrevolt/breakout-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_dependency "gosu", "~> 0.7.50"
end
