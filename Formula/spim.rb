class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  url "https://svn.code.sf.net/p/spimsimulator/code", :revision => 707
  version "9.1.19"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    rebuild 1
    sha256 "dd41b11f1fbbb7e2a71d95ac3047430de08333ee3a78c33993398b967b51a376" => :mojave
    sha256 "84b00e8d38c6b7f063cf98e4c38e1e92132ad116f7068d46a9fdc958d820c67e" => :high_sierra
    sha256 "875166f0c8bcf6a5364eb54aee936af7bdee6d00a5087916730482524662ed32" => :sierra
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
