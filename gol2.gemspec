# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'gol2/version'
require 'gol2.rb'

PRYING = (ENV['PRYING'] == true) || false
require 'pry' if PRYING

Gem::Specification.new do |spec|
  spec.name          = "gol2"
  spec.version       = Gol2::VERSION
  spec.authors       = ["Eric Slick"]
  spec.email         = ["github@slickfamily.net"]

  spec.summary       = %q{Conway's Game of Life}
  spec.description   = %q{An expanded implementation of Conway's GOL: competing colonies and a simple player vs computer game.}
  spec.homepage      = "http://slickcode.us/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "http://localhost:9292/private"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|unit|integration|behavior)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency 'gosu', "~> 0.10"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency 'gosu', "~> 0.10"
end
