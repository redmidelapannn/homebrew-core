class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily"
  homepage "http://www.fox-toolkit.org/"
  url "http://fox-toolkit.org/ftp/fox-1.6.55.tar.gz"
  sha256 "172416625221e54dcc1c4293fc892b9695f1e952f4b895376e6604c6c3813d74"

  bottle do
    cellar :any
    rebuild 1
    sha256 "57ffb07f4b49280b419383928051f087dca6e1d9690aca563123fecc6ee804da" => :high_sierra
    sha256 "3b0ffbb0965482340e4136c53497cd2b0d2ce31e0fc2f28a971c9ba3f7843152" => :sierra
    sha256 "f0c76b5a045b02b51e4a62a47ae58d9cd581e9229dc202dfe7800bcc61e6f01b" => :el_capitan
  end

  depends_on :x11
  depends_on "freetype"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--prefix=#{prefix}",
                          "--with-x",
                          "--with-opengl"
    # Unset LDFLAGS, "-s" causes the linker to crash
    system "make", "install", "LDFLAGS="
    rm bin/"Adie.stx"
  end

  test do
    system bin/"reswrap", "-t", "-o", "text.txt", test_fixtures("test.jpg")
    assert_match "\\x00\\x85\\x80\\x0f\\xae\\x03\\xff\\xd9", File.read("text.txt")
  end
end
