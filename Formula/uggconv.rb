class Uggconv < Formula
  desc "Universal Game Genie code convertor"
  homepage "https://wyrmcorp.com/software/uggconv/index.shtml"
  url "https://wyrmcorp.com/software/uggconv/uggconv-1.0.tar.gz"
  sha256 "9a215429bc692b38d88d11f38ec40f43713576193558cd8ca6c239541b1dd7b8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "70f36f2256107f0883246e753bea5510f2706328c35b422ee40c0ce34d9182f3" => :sierra
    sha256 "3c4eea54feb49634ce804be276b33d469a2906b077e0afba19a7846eb7d317bd" => :el_capitan
    sha256 "e86179b6a2c4b22d55f3c6d79bfc7b97a47cf32daea6c49fcef37e26cc768d43" => :yosemite
  end

  def install
    system "make"
    bin.install "uggconv"
    man1.install "uggconv.1"
  end

  test do
    assert_equal "7E00CE:03    = D7DA-FE86\n",
      shell_output("#{bin}/uggconv -s 7E00CE:03")
  end
end
