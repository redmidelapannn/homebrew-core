class LibtorrentRasterbarAT11 < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_13/libtorrent-rasterbar-1.1.13.tar.gz"
  sha256 "30040719858e3c06634764e0c1778738eb42ecd0b45e814afa746329a948ead7"

  bottle do
    cellar :any
    sha256 "4eecbeae2d042dc70b65b01b48a46655ba16a1cddfe10472f339e2bc0c8fd0ea" => :mojave
    sha256 "af8a80a3c356b3127e089537db082155890640412c7bcaf731af567d4379b762" => :high_sierra
    sha256 "e3a762b4cd976dd6c4e7d575755e605791a04226ab1d379c737803acc41cd93b" => :sierra
  end

  keg_only :versioned_formula

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
