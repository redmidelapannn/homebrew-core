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
    sha256 "c036a682c1027521bac61a9dcb7573f4ec55fd7773361aa11eb5a92b4762c9f7" => :sierra
    sha256 "4e098abe19e894e3f50cbdd3278735ae8c02235b44d80a6de2a115e2073d6814" => :el_capitan
    sha256 "f07ae2ec3da18a5da0b03dddc12614c65443530957a19bbb83a18fb17c54535a" => :yosemite
  end

  devel do
    url "https://github.com/elixir-lang/elixir/archive/v1.5.0-rc.0.tar.gz"
    version "1.5.0-rc.0"
    sha256 "26731f227272aedf11f5ac11887f52b4b478e9c849345515855c01601d5f494e"
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
