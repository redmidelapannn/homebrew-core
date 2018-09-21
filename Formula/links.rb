class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.17.tar.bz2"
  sha256 "d8389763784a531acf7f18f93dd0324563bba2f5fa3df203f27d22cefe7a0236"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8d633a0869ea398d86c689a93d452f8ae0378318b4ea91ddf0da401bfe81e5c2" => :mojave
    sha256 "0b321c8fbfab70561ecb1311871333774e00d0062703b8bd072aaae1eac65ff3" => :high_sierra
    sha256 "818ec3e900f85000cb6d819efcac97faeb5c64fbf104914cf47ee703ae5c783e" => :sierra
    sha256 "5ab26b848adb777767237de388eac6efa4d25ab166cc322ce75e40f88dfe5e21" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "jpeg" => :optional
  depends_on "librsvg" => :optional
  depends_on "libtiff" => :optional
  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --without-lzma
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
