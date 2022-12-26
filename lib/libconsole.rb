# frozen_string_literal: true

require_relative "libconsole/version"
require_relative "libconsole/ci/github"

module Libconsole
  class Error < StandardError; end

  # Your code goes here...
  class Github
    extend Libconsole::CI::Github
  end
end
