# frozen_string_literal: true

RSpec.describe Libconsole::CI::Github::Attr do
  attr = Libconsole::CI::Github::Attr.new

  it "add_path work well" do
    attr.add_path("/usr/bin")
    attr.add_path("$HOME/bin")

    print "PATH: ", attr.github_path
    puts

    expect(attr.github_path.include?("/usr/bin:$HOME/bin")).to eq true
  end
  it "export_variable work well" do
    attr.export_variable("foo", "bar")
    attr.export_variable("CC", "gcc")

    print "ENV: ", attr.github_env
    puts

    expect(attr.github_env.include?("foo=bar\nCC=gcc\n")).to eq true
  end
  it 'input_("FOO", "bar") got "bar"' do
    attr.input_("FOO", "bar")
    print "INPUT_FOO: ", attr.input_("FOO")
    puts

    expect(attr.input_("FOO")).to eq "bar"
  end
  it 'state_("FOO", "bar") got "bar"' do
    attr.state_("FOO", "bar")
    print "STATE_FOO: ", attr.state_("FOO")
    puts

    expect(attr.state_("FOO")).to eq "bar"
  end

  it "Github Attr func" do
    print "GITHUB_STEP_SUMMARY: ", attr.summary
    puts

    print "GITHUB_STATE: ", attr.state
    puts

    print "GITHUB_OUTPUT: ", attr.output
    puts

    print "RUNNER_DEBUG: ", attr.debug?
    puts
  end

  # it '""' do
  #   expect("").to eq ""
  # end
end
