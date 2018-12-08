class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  url "https://svn.code.sf.net/p/spimsimulator/code", :revision => 707
  version "9.1.19"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    rebuild 1
    sha256 "d2e1224ca9d7eecabd9ff53c171b3ef6fe9e5d22496bf923de894e37d985d860" => :high_sierra
    sha256 "735da1861b10cb427278e60a7db7c457f7d08d1ed901cba9b5f0be26a2697142" => :sierra
  end

  def install
    bin.mkpath
    cd "spim" do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "test"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}",
                                "MAN_DIR=#{man1}"
    end
  end

  test do
    assert_match "__start", pipe_output("#{bin}/spim", "print_symbols")
  end
end
