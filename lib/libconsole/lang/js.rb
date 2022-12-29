# frozen_string_literal: true

require_relative "../color"

module Libconsole
  module Lang
    # https://developer.mozilla.org/en-US/docs/Web/API/console
    module JS
      extend Libconsole::Color
      include Libconsole::Color

      def default
        @debug = false

        @count_state = {}
        @time_start_state = {}

        @indet = ""
        @indet_symbol = " "
        @indet_size = 4
        @indet_count = 0

        @group_tier = 0
        @group_symbol = blue("|")
      end

      def group_inner
        @group_tier.positive?
      end
      private :group_inner

      def pre_puts(argv)
        pre = if group_inner
                @indet + @group_symbol
              else
                @indet
              end
        puts _prefix(pre, argv)
      end
      private :pre_puts

      # logging
      def log(*argv)
        pre_puts _color_space(argv)
      end

      def info(*argv)
        argv.unshift("~")
        pre_puts blue(_color_space(argv))
      end

      def warn(*argv)
        argv.unshift("?")
        pre_puts yellow(_color_space(argv))
      end

      def error(*argv)
        argv.unshift("!")
        pre_puts red(_color_space(argv))
      end

      def debug(*argv)
        pre_puts bgred(_color_space(argv)) if @debug
      end

      def assert(assertion = false, *args)
        args.unshift("!= Assertion failed:")
        pre_puts red(_color_space(args)) unless assertion
      end

      def clear
        !Gem.win_platform? ? (system "clear") : (system "cls")
        pre_puts italic("Console was cleared")
      end

      def count(label = "default")
        @count_state[:label] = 0 unless @count_state[:label]
        @count_state[:label] += 1
        pre_puts "#{label}: #{@count_state[:label]}"
      end

      def count_reset(label = "default")
        unless @count_state[:label]
          pre_puts "Count for '#{label}' does not exist"
          return
        end
        @count_state[:label] = 0
        pre_puts "#{label}: #{@count_state[:label]}"
      end

      def dir(*argv)
        pp(argv)
      end

      def dirxml(*argv)
        pp(argv)
      end

      def group(label = "console.group")
        @group_tier += 1
        pre_puts bold(label)
        @indet_count += @indet_size
        @indet = @indet_symbol * @indet_count
      end

      def group_collapsed(label = "console.group")
        @group_tier += 1
        pre_puts bold(label)
        @indet_count += @indet_size
        @indet = @indet_symbol * @indet_count
      end

      def group_end
        @indet_count -= @indet_size
        @indet_count = 0 if @indet_count.negative?
        @indet = @indet_symbol * @indet_count
        @group_tier -= 1
        @group_tier = 0 if @group_tier.negative?
      end

      def table(*msg)
        pre_puts msg.join(" ")
      end

      def time(label = "default")
        if @time_start_state[:label]
          pre_puts yellow("Timer '#{label}' already exists")
        else
          # https://docs.ruby-lang.org/en/master/Time.html#method-i-tv_usec
          @time_start_state[:label] = Time.now
        end
      end

      def time_end(label = "default")
        unless @time_start_state[:label]
          pre_puts "Timer '#{label}' does not exist"
          return
        end
        now = Time.now
        range = now - @time_start_state[:label]
        range_ms = (range.to_f * 1000).truncate(6)
        pre_puts "#{label}: #{range_ms} ms - timer ended"
        @time_start_state[:label] = nil
      end

      def time_log(label = "default")
        unless @time_start_state[:label]
          pre_puts "Timer '#{label}' does not exist"
          return
        end
        now = Time.now
        range = now - @time_start_state[:label]
        range_ms = (range.to_f * 1000).truncate(6)
        pre_puts "#{label}: #{range_ms} ms"
      end

      def trace(*argv)
        if argv.empty?
          pre_puts "console.trace"
        else
          pre_puts argv.join(" ")
        end
      end

      private

      def _color_space(argv)
        arr = []
        argv.each do |arg|
          if arg.instance_of?(String)
            arr.push arg
          elsif arg.instance_of?(TrueClass)
            arr.push bgblue(arg)
          elsif arg.instance_of?(FalseClass)
            arr.push bgblue("false")
          elsif arg.instance_of?(Integer)
            arr.push bgcyan(arg)
          elsif arg.instance_of?(Float)
            arr.push bgmagenta(arg)
          elsif arg.nil?
            arr.push bgwhite("nil")
          else
            arr.push cyan(arg)
          end
        end
        arr.join(" ")
      end

      def _prefix(pre, args)
        args unless pre
        %(#{pre}#{args})
      end
    end
  end
end
