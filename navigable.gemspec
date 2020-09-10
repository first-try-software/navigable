require_relative "lib/navigable/version"

Gem::Specification.new do |spec|
  spec.name          = "navigable"
  spec.version       = Navigable::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Alan Ridlehoover", "Fito von Zastrow"]
  spec.email         = ["alan@ridlehoover.com", "adolfovon@gmail.com"]

  spec.summary       = %q{Ahoy! Navigable will get you there!}
  spec.description   = %q{We hold these truths to be self-evident, that not all objects are created equal, that poorly structured code leads to poorly tested code, and that poorly tested code leads to rigid software and fearful engineers.\n\nWe believe a framework should break free of this tyranny. It should be simple, testable, and fast. It can be opinionated. But, it should leverage SOLID principles to guide us toward well structured, well tested, maleable code that is truly navigable.}
  spec.homepage      = "https://github.com/first_try/navigable"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/first_try/navigable"
  spec.metadata["bug_tracker_uri"] = "https://github.com/first_try/navigable/issues"

  spec.files         = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "assets"]

  spec.add_dependency "manufacturable", "~> 1.4"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~>0.4"
  spec.add_development_dependency "simplecov", "~>0.16"
end
