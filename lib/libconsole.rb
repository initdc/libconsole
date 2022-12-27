# frozen_string_literal: true

require_relative "libconsole/version"
require_relative "libconsole/ci/github"
require_relative "libconsole/lang/js"

module Libconsole
  class Error < StandardError; end

  # Your code goes here...
  class Github
    extend Libconsole::CI::Github
  end

  class JS
    extend Libconsole::Lang::JS
  end
end
