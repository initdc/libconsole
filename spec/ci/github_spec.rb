# frozen_string_literal: true

RSpec.describe Libconsole::CI::Github do
  it "run as CI workflow on github actions" do
    Libconsole::Github.debug("debug")
    Libconsole::Github.info("info")
    Libconsole::Github.notice("notice")
    Libconsole::Github.warning("warning")
    Libconsole::Github.error("error")

    Libconsole::Github.group("group")
    Libconsole::Github.info("in group")
    Libconsole::Github.group("inner group")
    Libconsole::Github.info("in inner group")
    Libconsole::Github.info("hello from inner group of group")
    Libconsole::Github.end_group
    Libconsole::Github.end_group

    Libconsole::Github.add_mask("password")
    Libconsole::Github.stop_commands("asdf^qwerty") do |tk|
      Libconsole::Github.info("hide me")
      Libconsole::Github.info(tk)
    end

    Libconsole::Github.echo('"### Hello world! :rocket:" >> $GITHUB_STEP_SUMMARY')
    puts Libconsole::Github.echo("### Hello again!")
    puts `echo '### Hello one more time!'`
  end
end
