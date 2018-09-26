class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_8/libtorrent-rasterbar-1.1.8.tar.gz"
  sha256 "6bbf8fd0430e27037b09a870c89cfc330ea41816102fe1d1d16cc7428df08d5d"
  revision 1

  bottle do
    cellar :any
    sha256 "a4ee7a9790c9f769ed1f60568ab2d927a6cc9efeb5d4a3d5daf51ae00cde8576" => :mojave
    sha256 "998bbc39d65797dbc033a14b6e7445e6222dcaa98e80a4da7ae7526d55f7b3c9" => :high_sierra
    sha256 "d5b3dc306e4e6aefd411c49acb872d2dab503809c2e3662c1e112e7af19deccf" => :sierra
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "with-python" => "with-python@2"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "python@2" => :optional
  depends_on "boost-python" if build.with? "python@2"

  def install
    ENV.cxx11
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-encryption",
            "--prefix=#{prefix}",
            "--with-boost=#{Formula["boost"].opt_prefix}"]

    # Build python bindings requires forcing usage of the mt version of boost_python.
    if build.with? "python@2"
      args << "--enable-python-binding"
      args << "--with-boost-python=boost_python27-mt"
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
