class Drafter < Formula
  desc "API Blueprint document parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v3.2.7/drafter-v3.2.7.tar.gz"
  sha256 "a2b7061e2524804f153ac2e80f6367ae65dfcd367f4ee406eddecc6303f7f7ef"

  bottle do
    cellar :any
    sha256 "7bab4f345d81f3c1a97785f57c708f66b450979e65b33c7188d014ce8366c53c" => :sierra
    sha256 "3e371038c879f0267f57676a7847fb2ee7b9934a25f27aa588d153879c53b5f9" => :el_capitan
    sha256 "52057155e7777b01fa60287393bb23865e818a596325089aaf5e68b0501ac384" => :yosemite
  end

  def install
    system "./configure", "--shared"
    system "make", "drafter"
    bin.install "bin/drafter"
    (include + "drafter").install "src/drafter.h"
    lib.install "build/out/Release/libdrafter.dylib"
  end

  test do
    system bin/"drafter", "--help"
  end
end
