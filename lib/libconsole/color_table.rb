# frozen_string_literal: true

class ColorTable
  # rubocop:disable Layout/HashAlignment

  # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
  Escape = {
    ctr:  "^[",
    uni:  "\u001b",
    oct:  "\033",
    hex:  "\x1B",
    dec:  "27",
    lang: "\e"
  }

  # https://gist.github.com/iamnewton/8754917
  ColorFormat = {
    :regular   => 0,    :bold       => 1,
    :dim       => 2,    :italic     => 3,
    :underline => 4,    :blink      => 5,
    :fastblink => 6,    :reverse    => 7,
    :hide      => 8,    :strike     => 9
  }

  def _no_empty(argv)
    argv.any? ? argv : nil
  end

  Escape.each do |std, pre|
    define_method("#{std}_one") do |n = 0|
      "#{pre}[#{n}m"
    end

    define_method("#{std}_code") do |*argv, code: [0]|
      _code = _no_empty(argv) || code
      "#{pre}[#{_code.join(";")}m"
    end
  end

  Escape.each do |std, pre|
    define_method("#{std}_one_table") do
      puts "#{std}_one_table"
      Array(0..10).each do |col|
        Array(0..9).each do |row|
          num = col * 10 + row
          print "#{pre}[#{num}m", num.to_s.center(5)
          print "#{pre}[0m"
        end
        puts
      end
    end

    define_method("#{std}_code_table") do |*argv, code: [0], name: nil|
      _code = _no_empty(argv) || code
      _name = name || _code

      puts "#{std}_code_table(#{_name})"
      Array(0..10).each do |col|
        Array(0..9).each do |row|
          num = col * 10 + row
          print "#{pre}[#{_code.join(";")};#{num}m", num.to_s.center(5)
          print "#{pre}[0m"
        end
        puts
      end
    end

    define_method("#{std}_fmt_table") do |*argv, code: [], name: nil|
      _code = argv[0] ||code|| 0
      _name = argv[1] ||name|| _code

      puts "#{std}_fmt_table(#{_name})"
      Array(0..10).each do |col|
        Array(0..9).each do |row|
          num = col * 10 + row
          print "#{pre}[#{_code};#{num}m", num.to_s.center(5)
          print "#{pre}[0m"
        end
        puts
      end
    end

    define_method("#{std}_256_table") do |*argv, bg: false|
      _bg = argv[0] || bg
      _code = !_bg ? "38" : "48"

      puts "#{std}_256_table(bg: #{_bg})"
      Array(0..15).each do |col|
        Array(0..15).each do |row|
          num = col * 16 + row
          print "#{pre}[#{_code};5;#{num}m", num.to_s.center(5)
          print "#{pre}[0m"
        end
        puts
      end
    end

    define_method("#{std}_rgb_table") do |*argv, bg: false, rgb: [127, 127, 127], index: []|
      _rgb = _no_empty(argv) || rgb
      _code = !bg ? "38" : "48"

      puts "#{std}_rgb_table(rgb: #{_rgb}, bg: #{bg}, index: #{index})"
      Array(0..15).each do |col|
        Array(0..15).each do |row|
          num = col * 16 + row

          unless index.empty?
            index.each do |idx|
              _rgb[idx] = num
            end
          end

          print "#{pre}[#{_code};2;#{_rgb.join(";")}m", num.to_s.center(5)
          print "#{pre}[0m"
        end
        puts
      end
    end
  end
end

c = ColorTable.new

print c.uni_one(31), "test-one"
print c.uni_one
puts 
puts "reset"

print c.uni_code(38, 2, 160, 0, 160), "test-rgb"
print c.uni_code
puts
puts "reset"

c.uni_one_table

c.uni_code_table(2)

ColorTable::ColorFormat.each do |name, code|
  c.uni_fmt_table(code, name)
end

c.uni_256_table
c.uni_256_table(bg: true)

c.uni_rgb_table(bg: true, index: [0])
# c.uni_rgb_table(bg: true, index: [1])
# c.uni_rgb_table(bg: true, index: [2])
# c.uni_rgb_table(bg: true, index: [0,1])
# c.uni_rgb_table(bg: true, index: [0,2])
# c.uni_rgb_table(bg: true, index: [1,2])
# c.uni_rgb_table(bg: true, index: [0,1,2])

rgb = [169, 169, 169]

c.uni_rgb_table(169, 169, 169, bg: true, index: [0])
# c.uni_rgb_table(rgb: rgb, bg: true, index: [1])
# c.uni_rgb_table(rgb: rgb, bg: true, index: [2])
# c.uni_rgb_table(rgb: rgb, bg: true, index: [0,1])
# c.uni_rgb_table(rgb: rgb, bg: true, index: [0,2])
c.uni_rgb_table(rgb: rgb, bg: true, index: [1,2])
# c.uni_rgb_table(rgb: rgb, bg: true, index: [0,1,2])
