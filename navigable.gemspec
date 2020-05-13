require_relative 'lib/navigable/version'

Gem::Specification.new do |spec|
  spec.name          = "navigable"
  spec.version       = Navigable::VERSION
  spec.authors       = ["Alan Ridlehoover", "Fito von Zastrow"]
  spec.email         = ["alan@ridlehoover.com", "adolfovon@gmail.com"]

  spec.summary       = %q{Navigable routes RESTful HTTP requests to corresponding command objects.}
  spec.homepage      = "https://github.com/first_try/navigable"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/first_try/navigable"
  spec.metadata["bug_tracker_uri"] = "https://github.com/first_try/navigable/issues"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "http_router"
end
