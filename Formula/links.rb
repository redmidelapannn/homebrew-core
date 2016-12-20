class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.14.tar.bz2"
  sha256 "f70d0678ef1c5550953bdc27b12e72d5de86e53b05dd59b0fc7f07c507f244b8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2bb9719a57679f475d1092a4627f94cf3193e9f6fa08f455eea32eb685a76967" => :sierra
    sha256 "73ea52eebab66a7bdc7b02d16b3355a896e204caccdac4b2693fec152b354b3b" => :el_capitan
    sha256 "d24b5f8b2bad0ae583b01b0705e61595b2869de25bea49a1ba4a340d6ee38342" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "libtiff" => :optional
  depends_on "jpeg" => :optional
  depends_on "librsvg" => :optional
  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--enable-graphics" if build.with? "x11"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-librsvg" if build.without? "librsvg"

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
