require "bundler/setup"
require "feeble"
require "pry-byebug"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :be_a_token do |type, value = nil, meta = nil|
  match do |actual|
    actual_value, actual_meta = actual

    return false if actual_meta[:type] != type
    return true if ! value

    valid = actual_value == value
    return valid if ! meta

    valid && expect(actual_meta).to(include(meta))
  end
end

RSpec::Matchers.alias_matcher :a_token, :be_a_token
