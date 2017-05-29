class Stone < Formula
  desc "TCP/IP packet repeater in the application layer"
  homepage "http://www.gcd.org/sengoku/stone/"
  url "http://www.gcd.org/sengoku/stone/stone-2.3e.tar.gz"
  sha256 "b2b664ee6771847672e078e7870e56b886be70d9ff3d7b20d0b3d26ee950c670"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a56aeacb06dc93631e25dbd5e615b240f41ea83c299034e2bac881f5e975cf02" => :sierra
    sha256 "68b665f9302414b0f5ae29c4693eb67212513e0d6f52a2812a1fa0ff48f63c7d" => :el_capitan
    sha256 "12c95ae2ad7d50d95cbd14fb8440985031b59825e21fcfc1663f8b51248bc436" => :yosemite
  end

  deprecated_option "with-ssl" => "with-openssl"

  depends_on "openssl" => :optional

  def install
    if build.with? "openssl"
      inreplace "Makefile", "SSL=/usr", "SSL=#{Formula["openssl"].opt_prefix}"
      system "make", "macosx-ssl"
    else
      system "make", "macosx"
    end
    bin.install "stone"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stone -h 2>&1", 1)
  end
end
