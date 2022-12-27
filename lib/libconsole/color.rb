# frozen_string_literal: true

module Libconsole
  module Color
    # https://dev.to/truemark/11-most-asked-questions-about-rubocop-38al

    # rubocop:disable Layout/HashAlignment

    # https://github.com/rubyworks/ansi/blob/master/lib/ansi/bbcode.rb
    ## ANSIname => ANSIcode LUT
    ANSINAME2CODE = {
      "reset"     => "\e[0m",    "bold"       => "\e[1m",
      "dim"       => "\e[2m",    "italic"     => "\e[3m",
      "underline" => "\e[4m",    "blink"      => "\e[5m",
      "fastblink" => "\e[6m",    "reverse"    => "\e[7m",
      "hide"      => "\e[8m",    "strike"     => "\e[9m",
      "black"     => "\e[0;30m", "darkgrey"   => "\e[1;30m",
      "red"       => "\e[0;31m", "lightred"   => "\e[1;31m",
      "green"     => "\e[0;32m", "lightgreen" => "\e[1;32m",
      "brown"     => "\e[0;33m", "yellow"     => "\e[1;33m",
      "blue"      => "\e[0;34m", "lightblue"  => "\e[1;34m",
      "purple"    => "\e[0;35m", "magenta"    => "\e[1;35m",
      "cyan"      => "\e[0;36m", "lightcyan"  => "\e[1;36m",
      "grey"      => "\e[0;37m", "white"      => "\e[1;37m",
      "bgblack"   => "\e[40m",   "bgred"      => "\e[41m",
      "bggreen"   => "\e[42m",   "bgyellow"   => "\e[43m",
      "bgblue"    => "\e[44m",   "bgmagenta"  => "\e[45m",
      "bgcyan"    => "\e[46m",   "bgwhite"    => "\e[47m"
    }.freeze
    # rubocop:enable Layout/HashAlignment

    ANSINAME2CODE.each do |name, code|
      define_method(name) do |any = nil|
        if any
          %(#{code}#{any}\e[0m)
        else
          code
        end
      end
    end
  end
end
