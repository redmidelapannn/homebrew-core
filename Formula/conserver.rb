class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://www.conserver.com/conserver-8.2.1.tar.gz"
  sha256 "251ae01997e8f3ee75106a5b84ec6f2a8eb5ff2f8092438eba34384a615153d0"

  bottle do
    rebuild 1
    sha256 "504d615ddd99ccce1e0e88a73b1a9fbcfa0f975f2285ff385656b243bdd80aa6" => :high_sierra
    sha256 "26a753e15050f03a88389e18055a2cabe079e08d145df532fbfd24afca570dfe" => :sierra
    sha256 "3cbcffcf8af0aa9a71721fb21a0c0faa695f5a70862bcb59ac16596943ce5f2b" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
