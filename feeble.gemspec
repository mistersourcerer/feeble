lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "feeble/version"

Gem::Specification.new do |spec|
  spec.name          = "feeble"
  spec.version       = Feeble::VERSION
  spec.authors       = ["Ricardo Valeriano"]
  spec.email         = ["mister.sourcerer@gmail.com"]
  spec.summary       = %q{
    Feeble is a toy language.
  }
  spec.description   = %q{
    Don't use it on production :).
    This is a toy language that @mr_sourcerer created
    with the sole purpose of learning and understanding
    how one can even do that!
  }
  spec.homepage      = "http://github.com/mistersourcerer/feeble"
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"

  spec.add_dependency "zeitwerk"
end
