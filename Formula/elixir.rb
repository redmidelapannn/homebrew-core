class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.8.2.tar.gz"
  sha256 "cf9bf0b2d92bc4671431e3fe1d1b0a0e5125f1a942cc4fdf7914b74f04efb835"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ed5b15dadfe5a85a3b098cfd2385478be02958fd7c924a2df1537d71ffc16205" => :mojave
    sha256 "4f29122c56649e1b99806177d9e95f5d736f4f0eff3b1d8f6375c6fad8265059" => :high_sierra
    sha256 "d5e860afb6f49296b6aebec1d3df4d7b931804055f399c6f72a74c4d930ee0fb" => :sierra
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"]

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
