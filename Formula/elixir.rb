class Elixir < Formula
  desc "Dynamic, functional language designed for building scalable and maintainable applications"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.1.tar.gz"
  sha256 "91109a1774e9040fb10c1692c146c3e5a102e621e9c48196bfea7b828d54544c"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    rebuild 1
    sha256 "0f0dc49475ddcf20270af25e925eb7aba246a1fc686f1a79b925cc5378e957d1" => :high_sierra
    sha256 "e716ad726771b7771671ce44caf3beea7649adeb621f7e6f696f9f2ea609307a" => :sierra
    sha256 "f8b252dcf1d260c8be9cbd6500eca5afaefaf6c6cbf6d037d24650172f756e61" => :el_capitan
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
