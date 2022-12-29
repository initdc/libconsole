# frozen_string_literal: true

module Libconsole
  module Color
    # https://dev.to/truemark/11-most-asked-questions-about-rubocop-38al

    # rubocop:disable Layout/HashAlignment

    # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
    Escape = {
      uni:  "\u001b",
      oct:  "\033",
      hex:  "\x1B",
      lang: "\e"
    }

    # https://gist.github.com/iamnewton/8754917
    Format = {
      reset:     [0, "E"],  bold:    [1, "B"],
      dim:       [2, "D"],  italic:  [3, "I"],
      underline: [4, "U"],  blink:   [5, "N"],
      fastblink: [6, "F"],  reverse: [7, "V"],
      hide:      [8, "H"],  strike:  [9, "S"]
    }

    # https://ss64.com/nt/syntax-ansi.html
    Color = {
      black:     [0, "K"],  red:     [1, "R"],
      green:     [2, "G"],  yellow:  [3, "Y"],
      blue:      [4, "L"],  magenta: [5, "M"],
      cyan:      [6, "C"],  white:   [7, "W"]
    }

    Range = {
      ""        => 30,
      "bg"      => 40,
      "light"   => 90,
      "bglight" => 100
    }

    def _no_empty(argv)
      argv.any? ? argv : nil
    end

    Escape.each do |std, pre|
      Format.each do |name, pair|
        code = pair[0]
        alias_name = pair[1]

        fn_name = "#{std}_#{name}"
        define_method(fn_name) do |any = nil|
          if any
            "#{pre}[#{code}m#{any}#{pre}[0m"
          else
            "#{pre}[#{code}m"
          end
        end

        alias_method alias_name, fn_name
        alias_method name, fn_name if std == :oct
      end

      Range.each do |n_pre, c_base|
        Color.each do |n_base, pair|
          c_add = pair[0]
          alias_name = pair[1]

          name = "#{n_pre}#{n_base}"
          code = c_base + c_add
          fn_name = "#{std}_#{name}"
          define_method(fn_name) do |any = nil|
            if any
              "#{pre}[#{code}m#{any}#{pre}[0m"
            else
              "#{pre}[#{code}m"
            end
          end

          alias_method alias_name, fn_name if n_pre == ""
          alias_method "G#{alias_name}", fn_name if n_pre == "bg"
          alias_method "L#{alias_name}", fn_name if n_pre == "light"
          alias_method "GL#{alias_name}", fn_name if n_pre == "bglight"

          alias_method name, fn_name if std == :oct
        end
      end
    end
  end
end
