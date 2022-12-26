# frozen_string_literal: true

# it will made github workflow exit,
# run it from another single workflow
# rspec spec/ci/failed.rb
RSpec.describe Libconsole::CI::Github do
  it 'failed("crash") got exit 1' do
    Process.fork { Libconsole::Github.failed("exit when should crash") }
    Process.wait

    expect($?.exitstatus).to eq 1
  end
end
