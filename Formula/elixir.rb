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
    sha256 "40eaa8997f6520604b9bc6ceabed599b645c3b1723d91954f88035358980b7e2" => :sierra
    sha256 "e1c23bbd10a700112aeb8abbd002baf96e841daa2981647ef514aa68e596e6b6" => :el_capitan
    sha256 "1675e8510033178984e5154fa4c20be737c9a1691457466e2b5e120205b586c9" => :yosemite
  end

  devel do
    url "https://github.com/elixir-lang/elixir/archive/v1.5.0-rc.2.tar.gz"
    version "1.5.0-rc.2.tar.gz"
    sha256 "b32daa28ce20f34f19ddfa66db6f2272f3416f03997b960bd994d08712bbc2ba"
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
