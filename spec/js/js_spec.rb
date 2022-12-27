# frozen_string_literal: true

# it will made github workflow exit,
# run it from another single workflow
# rspec spec/ci/failed.rb
RSpec.describe Libconsole::Lang::JS do
  it '""' do
    warn(("warn"))
    expect("").to eq ""
  end

  # it '""' do
  #   expect("").to eq ""
  # end
end
