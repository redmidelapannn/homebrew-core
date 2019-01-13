class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.17.tar.bz2"
  sha256 "d8389763784a531acf7f18f93dd0324563bba2f5fa3df203f27d22cefe7a0236"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "f9004405755b2d4de642e217f6846596f02fdf021138b88172ea29bb26b7b753" => :mojave
    sha256 "febe84a620b4ef88d0347bd74b6a0e79df466d58e9d745912bbf798aa9a9ff84" => :high_sierra
    sha256 "7eae131755d945051bc468691daf4430816f96ee8eaaa66569904d53d5bcf1aa" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "openssl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --without-lzma
    ]

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
