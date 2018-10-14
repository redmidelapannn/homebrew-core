class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_9/libtorrent-rasterbar-1.1.9.tar.gz"
  sha256 "d57a0f5b159f58003c3031943463503f0d05ae3e428dd7c2383d1e35fb2c4e8c"
  revision 1

  bottle do
    cellar :any
    sha256 "2e5f0195af83c7ea9bdefd81b354104ae8d210cff8821a2908dca892c5ed92b9" => :mojave
    sha256 "931706323cc2f23c21fd998e7552ff759a80bad1ae64ffc8d52fa3f89b7f3cea" => :high_sierra
    sha256 "0507d585f56414411c9b603a738eef498c41bdfa99576b7767b7bb400754b1ac" => :sierra
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "openssl"
  depends_on "python@2"

  def install
    ENV.cxx11

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-encryption
      --enable-python-binding
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-boost-python=boost_python27-mt
    ]

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
           "-I#{Formula["boost"].include}/boost",
           "-L#{Formula["boost"].lib}", "-lboost_system",
           libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
