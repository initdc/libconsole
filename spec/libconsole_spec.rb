# frozen_string_literal: true

RSpec.describe Libconsole do
  it "has a version number" do
    expect(Libconsole::VERSION).not_to be nil
  end

  it "can be extend as class method" do
    class MyClass1
      extend Libconsole::CI::Github
    end

    output = with_captured_stdout do
      MyClass1.info("Linux")
    end

    expect(output).to eq "Linux\n"
  end

  it "can be include as instance method" do
    class MyClass2
      include Libconsole::CI::Github
    end

    m = MyClass2.new
    output = with_captured_stdout do
      m.info("Linux")
    end

    expect(output).to eq "Linux\n"
  end

  it "can be inherited" do
    class MyClass < Libconsole::CI::Github::Attr
      extend Libconsole::CI::Github
    end

    output = with_captured_stdout do
      MyClass.info("Linux")
    end
    puts output

    m = MyClass.new
    m.export_variable("CC", "gcc")
    expect(m.github_env.include?("CC=gcc\n")).to eq true
  end
end
