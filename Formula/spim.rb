class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/spimsimulator/code", :revision => 681
  else
    url "http://svn.code.sf.net/p/spimsimulator/code", :revision => 681
  end
  version "9.1.17"

  bottle do
    rebuild 1
    sha256 "08025fc5ad657980592d524c3110ae4e3b764f51cf31380fe35e043045458b9b" => :sierra
    sha256 "646b6c0d326962c645bb7701729bddf90784582d402c40063d15de8c07878796" => :el_capitan
    sha256 "0de95836c7533b8bfda295acb7662769def0fa1c95c5f7c7ba78cb51d37f21ba" => :yosemite
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
