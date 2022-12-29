# frozen_string_literal: true

module Libconsole
  module Linux
    module Raw
      def default
        @debug = false
        @count_state = {}
        @time_start_state = {}
      end

      def pre_puts(argv, level = nil)
        pre = if level.instance_of?(String)
                "[#{level.center(6)}] "
              elsif level.instance_of?(0.1.class)
                # https://docs.ruby-lang.org/en/master/format_specifications_rdoc.html
                time = format("%.6f", level)
                t_size = time.size
                size = t_size > 12 ? t_size : 12
                "[#{time.rjust(size)}] "
              end
        str = argv.instance_of?(Array) ? argv.join(": ") : argv
        puts _prefix(pre, str)
      end
      private :pre_puts

      # dmesg -h
      #
      # Supported log levels (priorities):
      #    emerg - system is unusable
      #    alert - action must be taken immediately
      #     crit - critical conditions
      #      err - error conditions
      #     warn - warning conditions
      #   notice - normal but significant condition
      #     info - informational
      #    debug - debug-level messages
      def info(*argv)
        pre_puts argv, "info"
      end

      def notice(*argv)
        pre_puts argv, "noti"
      end

      def warn(*argv)
        pre_puts argv, "warn"
      end

      def err(*argv)
        pre_puts argv, "erro"
      end

      def crit(*argv)
        pre_puts argv, "crit"
      end

      def alert(*argv)
        pre_puts argv, "aler"
      end

      def emerg(*argv)
        pre_puts argv, "emer"
      end

      def debug(*argv)
        pre_puts argv, "debu" if @debug
      end

      def assert(assertion = false, *args)
        pre_puts args, "asse" unless assertion
      end

      def clear
        !Gem.win_platform? ? (system "clear") : (system "cls")
      end

      def count(*argv)
        label = argv.empty? ? "default" : argv.shift
        @count_state[label.to_sym] = 0 unless @count_state[label.to_sym]
        @count_state[label.to_sym] += 1
        pre_puts [label, @count_state[label.to_sym], argv], "coun"
      end

      def count_reset(*argv)
        label = argv.empty? ? "default" : argv.shift
        unless @count_state[label.to_sym]
          pre_puts "Count for '#{label}' does not exist", "warn"
          return
        end
        @count_state[label.to_sym] = 0
        pre_puts [label, @count_state[label.to_sym], argv], "coun"
      end

      def time(*argv)
        label = argv.empty? ? "default" : argv.shift
        if @time_start_state[label.to_sym]
          pre_puts "Timer '#{label}' already exists", "warn"
        else
          @time_start_state[label.to_sym] = Time.now
          pre_puts [label, argv], 0.0
        end
      end

      def time_end(*argv)
        label = argv.empty? ? "default" : argv.shift
        unless @time_start_state[label.to_sym]
          pre_puts "Timer '#{label}' does not exist", "warn"
          return
        end
        now = Time.now
        range = now - @time_start_state[label.to_sym]
        pre_puts [label, "timer ended", argv], range.to_f
        @time_start_state[label.to_sym] = nil
      end

      def time_log(*argv)
        label = argv.empty? ? "default" : argv.shift
        unless @time_start_state[label.to_sym]
          pre_puts "Timer '#{label}' does not exist", "warn"
          return
        end
        now = Time.now
        range = now - @time_start_state[label.to_sym]
        pre_puts [label, argv], range.to_f
      end

      private

      def _prefix(pre, args)
        args unless pre
        %(#{pre}#{args})
      end
    end
  end
end
