class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.0.tar.gz"
  sha256 "28d93afac480a279b75c3e57ce53fb4c027217c8db55a19d364efe8ceccd1b40"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    rebuild 1
    sha256 "b030d85279cefd17ef6891498d9db381e01ba2c4d10f18abc1fbbee0d56a8fc6" => :high_sierra
    sha256 "6c53bf789b8f70c8981c464ffd0548546ab40e4e7c6e95883b265595a910a0f7" => :sierra
    sha256 "6b1a4122834457e3eae2c0d5d1473269d120e5a21ac176a16e542afd26b2d5b3" => :el_capitan
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "build_man"
    man1.install "man/elixir.1", "man/elixirc.1", "man/iex.1", "man/mix.1"
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
