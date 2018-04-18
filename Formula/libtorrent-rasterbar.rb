class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_6/libtorrent-rasterbar-1.1.6.tar.gz"
  sha256 "b7c74d004bd121bd6e9f8975ee1fec3c95c74044c6a6250f6b07f259f55121ef"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9b9f6bc4201e64b9db9bd3462acc546c2213382cd02ea85d4497370866552581" => :high_sierra
    sha256 "8273f11abecc5fc97e3e4f5636bf28aa399b20b52429f72c4e68c353362ed5dd" => :sierra
    sha256 "96287a864772405ff9b05b83817ec78a1e0a83b79f64f7702e500888d9e4e603" => :el_capitan
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "with-python" => "with-python@2"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python@2" => :optional
  depends_on "boost"
  depends_on "boost-python" if build.with? "python@2"

  # Fix "error: no member named 'prior' in namespace 'boost'"
  # Upstream issue from 18 Apr 2018 "Boost 1.67.0 build failure"
  # See https://github.com/arvidn/libtorrent/issues/2947
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/22e74f4/libtorrent-rasterbar/boost-1.67.diff"
    sha256 "65e9f05f69bdd439f967e127fd07475c77b2f7885c50457d36b170ed5e6a3bb9"
  end

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
