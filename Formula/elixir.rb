class Erlang18Requirement < Requirement
  fatal true
  default_formula "erlang"

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s", [erlang:system_info(otp_release) >= "18"])' -s erlang halt | grep -q '^true'`
    next unless $CHILD_STATUS.exitstatus.zero?
    erl
  end

  def message; <<-EOS.undent
    Erlang 18+ is required to install.

    You can install this with:
      brew install erlang

    Or you can use an official installer from:
      https://www.erlang.org/
    EOS
  end
end

class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.4.5.tar.gz"
  sha256 "bef1a0ea7a36539eed4b104ec26a82e46940959345ed66509ec6cc3d987bada0"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    rebuild 1
    sha256 "6e03e123892444c2bbab6c20575d9901572dd2803ad54d08772ff90d7b823f56" => :sierra
    sha256 "e3139fc9ec10dcaab750bc199d04429c664dcd9252bc60f1d664d08d41d2c0ba" => :el_capitan
    sha256 "d96d31fc6d009fcd63e6e0e391e0b2b5831f9abdb73d2b7627aa94b7ea64d170" => :yosemite
  end

  devel do
    url "https://github.com/elixir-lang/elixir/archive/v1.5.0-rc.1.tar.gz"
    version "1.5.0-rc.1"
    sha256 "1ad60996c2141e61d36fc9c87726fa4d71353c7017c6ceb75221fe1edea14f6b"
  end

  depends_on Erlang18Requirement

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
