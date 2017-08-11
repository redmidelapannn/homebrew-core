class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/spimsimulator/code", :revision => 707
  else
    url "http://svn.code.sf.net/p/spimsimulator/code", :revision => 707
  end
  version "9.1.19"

  bottle do
    sha256 "d52f4d9e09c85949d7dec36379a4e29f03aa884151c16b43a33d3d576b65de73" => :sierra
    sha256 "422ac2cbac2feee2361fd94b2c594e47fb8e5cf71e9df9272089415c0db6d65e" => :el_capitan
    sha256 "4ad8598c889fdd1fa87aba2f0b7cf642d2b239ff690a278d80ea4761dd1ca944" => :yosemite
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
