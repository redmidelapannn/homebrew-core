class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  url "https://mcabber.com/files/loudmouth/loudmouth-1.5.3.tar.bz2"
  sha256 "54329415cb1bacb783c20f5f1f975de4fc460165d0d8a1e3b789367b5f69d32c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "024a2c305c187b5166a73613f7513da44953f8d2ae4c4ea641112f4e42286b6a" => :sierra
    sha256 "8d32e34f6ddd38d350735c78c19576fbb7c6d7cda865e8b26357930a990eb449" => :el_capitan
    sha256 "409e054efcd62c58dde10a703e57fb4da56a0d0664e60a322b8ae69bfd0ca2d3" => :yosemite
  end

  head do
    url "https://github.com/mcabber/loudmouth.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidn"
  depends_on "gnutls"
  depends_on "gettext"

  def install
    system "./autogen.sh", "-n" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ssl=gnutls"
    system "make"
    system "make", "check"
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*.c"]
  end

  test do
    cp pkgshare/"examples/lm-send-async.c", testpath
    system ENV.cc, "lm-send-async.c", "-o", "test",
      "-L#{lib}", "-L#{Formula["glib"].opt_lib}", "-lloudmouth-1", "-lglib-2.0",
      "-I#{include}/loudmouth-1.0",
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test", "--help"
  end
end
