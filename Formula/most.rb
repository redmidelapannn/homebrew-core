class Most < Formula
  desc "Powerful paging program"
  homepage "https://www.jedsoft.org/most/"
  url "https://www.jedsoft.org/releases/most/most-5.0.0a.tar.bz2"
  sha256 "94cb5a2e71b6b9063116f4398a002a757e59cd1499f1019dde8874f408485aa9"

  head "git://git.jedsoft.org/git/most.git"

  bottle do
    rebuild 1
    sha256 "a71a3bb9844677517922056f550d4f88bc4b5f0c2eafba535aa6ce2073ba0cd0" => :high_sierra
    sha256 "809631bbbef2cbce5c5804fe9d2020845d708a5694bf9b556392c8f52a7ebbf2" => :sierra
    sha256 "684d9e6bce50614f7c44523f538ea7c5346f68c0de3a9250a940df62c37aeb32" => :el_capitan
  end

  depends_on "s-lang"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    text = "This is Homebrew"
    assert_equal text, pipe_output("#{bin}/most -C", text)
  end
end
