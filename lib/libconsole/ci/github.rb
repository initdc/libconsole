# frozen_string_literal: true

module Libconsole
  module CI
    # https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions
    module Github
      # logging
      def debug(message)
        puts "::debug::#{message}"
      end

      def info(message)
        puts message
      end

      def notice(message, *args, **opts)
        name = args[1] || opts[:name]
        line = args[2] || opts[:line] || 0
        end_line = args[3] || opts[:end_line] || 0
        title = args[4] || opts[:title]

        puts "::notice file=#{name},line=#{line},endLine=#{end_line},title=#{title}::#{message}"
      end

      def warning(message, *args, **opts)
        name = args[1] || opts[:name]
        line = args[2] || opts[:line] || 0
        end_line = args[3] || opts[:end_line] || 0
        title = args[4] || opts[:title]

        puts "::warning file=#{name},line=#{line},endLine=#{end_line},title=#{title}::#{message}"
      end

      def error(message, *args, **opts)
        name = args[1] || opts[:name]
        line = args[2] || opts[:line] || 0
        end_line = args[3] || opts[:end_line] || 0
        title = args[4] || opts[:title]

        puts "::error file=#{name},line=#{line},endLine=#{end_line},title=#{title}::#{message}"
      end

      def failed(...)
        error(...)
        exit 1
      end

      # formating
      def group(title)
        puts "::group::#{title}"
      end

      def end_group
        puts "::endgroup::"
      end

      def add_mask(value)
        puts "::add-mask::#{value}"
      end

      def stop_commands(end_token)
        puts "::stop-commands::#{end_token}"
        yield end_token
        puts "::#{end_token}::"
      end

      def echo(arg)
        `echo #{arg}`
      end

      # https://github.com/actions/toolkit/blob/main/packages/core/__tests__/core.test.ts
      # github attr_accessor
      class Attr
        attr_accessor :github_path, :github_env, :github_step_summary,
                      :github_state, :github_output,
                      # :input_, :state_,
                      :runner_debug

        alias summary github_step_summary
        alias state github_state
        alias output github_output

        def initialize
          @github_path = ENV["GITHUB_PATH"] || ""
          @github_env = ENV["GITHUB_ENV"] ? ENV["GITHUB_ENV"] + "\n" : ""
          @github_step_summary = ENV["GITHUB_STEP_SUMMARY"]
          @github_state = ENV["GITHUB_STATE"]
          @github_output = ENV["GITHUB_OUTPUT"]

          @runner_debug = ENV["RUNNER_DEBUG"]
        end

        def add_path(path)
          @github_path = _path_arr(@github_path).push(path).join(":")
        end

        def export_variable(key, val)
          @github_env += "#{key}=#{val}\n"
        end

        def input_(*argv)
          name = argv[0]
          val = argv[1]
          case argv.size
          when 1
            ENV["INPUT_#{name}"]
          when 2
            ENV["INPUT_#{name}"] = val
          end
        end

        def state_(*argv)
          name = argv[0]
          val = argv[1]
          case argv.size
          when 1
            ENV["STATE_#{name}"]
          when 2
            ENV["STATE_#{name}"] = val
          end
        end

        def debug?
          @runner_debug
        end

        private

        def _path_arr(str)
          if Gem.win_platform?
            str.split(":")
          else
            str.split(";")
          end
        end

        def _env_arr(str)
          # unix only
          str.split("\n")
        end
      end
    end
  end
end
