class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_2_1/libtorrent-rasterbar-1.2.1.tar.gz"
  sha256 "cceba9842ec7d87549cee9e39d95fd5ce68b0eb9b314a2dd0d611cfa9798762d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "24455ca69bac9243f897d5f163a1510b741fe738cd4fa2f7e93155fd80af21a7" => :mojave
    sha256 "98c50603d313390a4544959223c192b7bd4d1a85a8a703c7969d0682c1c79df1" => :high_sierra
    sha256 "8f47149a72cf895d6a0c7b8d47ac8a92e9b4f0e213967d8f0fd121b2eaed8f8f" => :sierra
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl"
  depends_on "python"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-encryption
      --enable-python-binding
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-boost-python=boost_python37-mt
      PYTHON=python3
    ]
    
    ENV.append "LDFLAGS", "-framework SystemConfiguration -framework CoreFoundation"

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    libexec.install "examples"
  end

  test do
    system ENV.cxx, "-std=c++11", "-I#{Formula["boost"].include}/boost",
                    "-L#{lib}", "-ltorrent-rasterbar",
                    "-L#{Formula["boost"].lib}", "-lboost_system",
                    "-framework", "SystemConfiguration",
                    "-framework", "CoreFoundation",
                    libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
