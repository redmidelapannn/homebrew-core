class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/spimsimulator/code", :revision => 712
  else
    url "http://svn.code.sf.net/p/spimsimulator/code", :revision => 712
  end
  version "9.1.20"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    sha256 "e31f1444c977b286469438500c812064ee63e6e0f5c5cd7fd297a35897c9ff9c" => :high_sierra
    sha256 "0b631ed6c2e3189f47bd53b127642141019d3eca583c54db4f3d81ff7dd342f6" => :sierra
    sha256 "48c195211fc0b7f3b988f39c3a016dcf31a20cdcf0bfb623470047834c590311" => :el_capitan
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
