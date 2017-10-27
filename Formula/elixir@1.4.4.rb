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

  def message; <<~EOS
    Erlang 18+ is required to install.

    You can install this with:
      brew install erlang

    Or you can use an official installer from:
      https://www.erlang.org/
    EOS
  end
end

class ElixirAT144 < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.4.4.tar.gz"
  sha256 "2d9d5faee079949f780c8f6a1ccba015d64ecf859ed87384ae4239d69be60142"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "a2408fe083c27deb1cf8576bb71950acbe42150e2928e642937a6a6409d27176" => :high_sierra
    sha256 "f6c844212023a5fd9da468ab666446cd52f7cc23165dc66fa59207f12d2c0721" => :sierra
    sha256 "35036f3d1e6eefe59893f28fe60eadf10e70792617e8cda270c1bd45bbac021e" => :el_capitan
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
