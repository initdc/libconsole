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
    "reset"     => "0",    "bold"       => "1",
    "dim"       => "2",    "italic"     => "3",
    "underline" => "4",    "blink"      => "5",
    "fastblink" => "6",    "reverse"    => "7",
    "hide"      => "8",    "strike"     => "9"
  }

  Escape.each do |std, pre|
    define_method("#{std}_one") do |n = 0|
      "#{pre}[#{n}m"
    end

    define_method("#{std}_more") do |*argv|
      "#{pre}[#{argv.join(";")}m"
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

    define_method("#{std}_fmt_table") do |code = "0", name = nil|
      name ||= code
      puts "#{std}_fmt_table(#{name})"
      Array(0..10).each do |col|
        Array(0..9).each do |row|
          num = col * 10 + row
          print "#{pre}[#{code};#{num}m", num.to_s.center(5)
          print "#{pre}[0m"
        end
        puts
      end
    end

    define_method("#{std}_256_table") do |bg: false|
      code = !bg ? "38" : "48"
      puts "#{std}_256_table(bg: #{bg})"
      Array(0..15).each do |col|
        Array(0..15).each do |row|
          num = col * 16 + row
          print "#{pre}[#{code};5;#{num}m", num.to_s.center(5)
          print "#{pre}[0m"
        end
        puts
      end
    end

    define_method("#{std}_rgb_table") do |*argv, bg: false, rgb: [], index: []|
      arr = argv || rgb
      code = !bg ? "38" : "48"
      puts "#{std}_rgb_table(bg: #{bg})"
      Array(0..15).each do |col|
        Array(0..15).each do |row|
          num = col * 16 + row

          unless index.empty?
            index.each do |idx|
              argv[idx] = num
            end
          end

          print "#{pre}[#{code};2;#{arr.join(";")}m", num.to_s.center(5)
          print "#{pre}[0m"
        end
        puts
      end
    end
  end
end

c = ColorTable.new

ColorTable::ColorFormat.each do |name, code|
  c.lang_fmt_table(code, name)
end

c.uni_256_table
c.uni_256_table(bg: true)

# puts c.uni_more(38, 2, 160, 0, 160), "test-rgb"

# c.uni_rgb_table(bg: true, index: [0])
# c.uni_rgb_table(bg: true, index: [1])
# c.uni_rgb_table(bg: true, index: [2])
# c.uni_rgb_table(bg: true, index: [0,1])
# c.uni_rgb_table(bg: true, index: [0,2])
# c.uni_rgb_table(bg: true, index: [1,2])
# c.uni_rgb_table(bg: true, index: [0,1,2])


rgb = [128, 128, 128]

c.uni_rgb_table(128, 128, 128, bg: true, index: [0])
c.uni_rgb_table(rgb: rgb, bg: true, index: [1])
c.uni_rgb_table(rgb: rgb, bg: true, index: [2])
c.uni_rgb_table(rgb: rgb, bg: true, index: [0,1])
c.uni_rgb_table(rgb: rgb, bg: true, index: [0,2])
c.uni_rgb_table(rgb: rgb, bg: true, index: [1,2])
c.uni_rgb_table(rgb: rgb, bg: true, index: [0,1,2])
