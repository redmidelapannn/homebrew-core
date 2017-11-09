class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "http://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_5/libtorrent-rasterbar-1.1.5.tar.gz"
  sha256 "103134068389155a0f2bccaca72a57765460eb8188495089dcad280dcf426930"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2912e571d247ef0b02bf92f9743326a1e4b30216d44ab3c7cfaa8dbcb37ead79" => :high_sierra
    sha256 "3bdc93e7879e1b07b27a6739935e1c6a8775c3e12a72abe41c308f1cef71135a" => :sierra
    sha256 "6d8848d11e9fe83a6339ab161a4f319430a0a2bc4c3dca0c313f351244059205" => :el_capitan
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :python => :optional
  depends_on "boost"
  depends_on "boost-python" if build.with? "python"

  def install
    ENV.cxx11
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-encryption",
            "--prefix=#{prefix}",
            "--with-boost=#{Formula["boost"].opt_prefix}"]

    # Build python bindings requires forcing usage of the mt version of boost_python.
    if build.with? "python"
      args << "--enable-python-binding"
      args << "--with-boost-python=boost_python-mt"
    end

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    libexec.install "examples"
  end

  test do
    system ENV.cxx, "-L#{lib}", "-ltorrent-rasterbar",
           "-I#{Formula["boost"].include}/boost", "-lboost_system",
           libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
