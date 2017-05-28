class Erlang18Requirement < Requirement
  fatal true
  default_formula "erlang"

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s", [erlang:system_info(otp_release) >= "18"])' -s erlang halt | grep -q '^true'`
    next unless $?.exitstatus.zero?
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
  url "https://github.com/elixir-lang/elixir/archive/v1.4.4.tar.gz"
  sha256 "2d9d5faee079949f780c8f6a1ccba015d64ecf859ed87384ae4239d69be60142"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    rebuild 1
    sha256 "26ad058438b103a0475dd9a50e5db6ece83bbcd43ef959d04f3b2fec9b3fbf68" => :sierra
    sha256 "def62ba3d1e18504937a2d910aa0e09b06f3f330711536c55da14e7324347074" => :el_capitan
    sha256 "c59e38c1ec139eb742426d77eb13e8f5b46b7aa3eb9c61b949ce75feaca12d9c" => :yosemite
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
