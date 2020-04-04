class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  url "https://svn.code.sf.net/p/spimsimulator/code", :revision => 729
  version "9.1.21"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    sha256 "d36ae15c1da180d045d2b105834143ea60899aec5c0addee4c2a31e8bb83747a" => :catalina
    sha256 "8b75517a00a1aff52b3b36725d82af07ff542713df1364881cb7e6a7d2ec99f9" => :mojave
    sha256 "6066f72f0ea0c14e962d489f276fbb671f0ef2afbf4bafa7079a18732d599166" => :high_sierra
  end

  def install
    bin.mkpath
    cd "spim" do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}",
                                "MAN_DIR=#{man1}"
    end
  end

  test do
    assert_match "__start", pipe_output("#{bin}/spim", "print_symbols")
  end
end
