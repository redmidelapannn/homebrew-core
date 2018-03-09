class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.3.zip"
  sha256 "a0aa1f276fb97344cbc653568f69ceea58c368cabea172bf6e1f16446cd02851"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "0a208cc12a6aa200e59afce99badbe74da7c7577afdbbedeb8bfb4b13593bdcb" => :high_sierra
    sha256 "61f089f21bbad95ce0744b757f4f0e87e821e5ceeae6275bf8b303fa6dec7d2d" => :sierra
    sha256 "41a23235a3367ea7b6bc88db643a6b5bdd436f050cde08b8f1de89d509200ec5" => :el_capitan
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
